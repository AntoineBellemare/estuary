module Estuary.Renderer where

import Data.Time.Clock
import qualified Sound.Tidal.Context as Tidal
import Control.Monad.IO.Class (liftIO)
import Control.Monad.State.Strict
import Control.Concurrent
import Control.Concurrent.MVar
import Control.Monad.Loops
import Data.Functor (void)
import Data.List (intercalate)
import Data.IntMap.Strict as IntMap
import Data.Maybe
import qualified Data.Map as Map

import Estuary.Types.Context
import Estuary.Types.Definition
import Estuary.Types.TextNotation
import Estuary.Tidal.Types
import Estuary.Tidal.ParamPatternable
import Estuary.Types.Live
import Estuary.Languages.TidalParsers
import Estuary.WebDirt.SampleEngine
import Estuary.RenderInfo
import Estuary.RenderState
import Estuary.Types.Tempo

type Renderer = StateT RenderState IO ()

renderPeriod :: NominalDiffTime
renderPeriod = 0.2

flushEvents :: Context -> Renderer
flushEvents c = do
  events <- gets dirtEvents
  liftIO $ if webDirtOn c then sendSounds (webDirt c) events else return ()
  liftIO $ if superDirtOn c then sendSounds (superDirt c) events else return ()
  modify' $ \x -> x { dirtEvents = []}
  return ()

renderTidalPattern :: UTCTime -> NominalDiffTime -> Tempo -> Tidal.ControlPattern -> [(UTCTime,Tidal.ControlMap)]
renderTidalPattern start range t p = events''
  where
    start' = (realToFrac $ diffUTCTime start (at t)) * cps t + beat t -- start time in cycles since beginning of tempo
    end = realToFrac range * cps t + start' -- end time in cycles since beginning of tempo
    events = Tidal.queryArc p (toRational start',toRational end) -- events with t in cycles
    events' = Prelude.filter Tidal.eventHasOnset events
    events'' = f <$> events'
    f (((w1,_),(_,_)),cMap) = (addUTCTime (realToFrac ((fromRational w1 - beat t)/cps t)) (at t),cMap)

sequenceToControlPattern :: (String,[Bool]) -> Tidal.ControlPattern
sequenceToControlPattern (sampleName,pat) = Tidal.s $ parseBP' $ intercalate " " $ fmap f pat
  where f False = "~"
        f True = sampleName


render :: Context -> Renderer
render c = do
  traverseWithKey (renderZone c) (definitions c)
  flushEvents c


renderZone :: Context -> Int -> Definition -> Renderer
renderZone c z d = do
  s <- get
  let prevDef = IntMap.lookup z $ cachedDefs s
  if prevDef == (Just d) then return () else renderZoneChanged c z d
  modify' $ \x -> x { cachedDefs = insert z d (cachedDefs s) }
  renderZoneAlways c z d


renderZoneChanged :: Context -> Int -> Definition -> Renderer
renderZoneChanged c z (Structure x) = do
  let newParamPattern = toParamPattern x
  s <- get
  modify' $ \x -> x { paramPatterns = insert z newParamPattern (paramPatterns s) }
renderZoneChanged c z (TextProgram x) = renderTextProgramChanged c z $ forRendering x
renderZoneChanged c z (Sequence xs) = do
  let newParamPattern = Tidal.stack $ Map.elems $ Map.map sequenceToControlPattern xs
  s <- get
  modify' $ \x -> x { paramPatterns = insert z newParamPattern (paramPatterns s) }
renderZoneChanged _ _ _ = return ()

renderZoneAlways :: Context -> Int -> Definition -> Renderer
renderZoneAlways c z (Structure _) = renderControlPattern c z
renderZoneAlways c z (TextProgram x) = renderTextProgramAlways c z $ forRendering x
renderZoneAlways c z (Sequence _) = renderControlPattern c z
renderZoneAlways _ _ _ = return ()


renderTextProgramChanged :: Context -> Int -> (TextNotation,String) -> Renderer
renderTextProgramChanged c z (TidalTextNotation x,y) = do
  s <- get
  let parseResult = tidalParser x y -- :: Either ParseError ControlPattern
  let newParamPatterns = either (const $ paramPatterns s) (\p -> insert z p (paramPatterns s)) parseResult
  let newErrors = either (\e -> insert z (show e) (errors (info s))) (const $ delete z (errors (info s))) parseResult
  modify' $ \x -> x { paramPatterns = newParamPatterns, info = (info s) { errors = newErrors} }


renderTextProgramChanged c z (Punctual,s) = return () -- placeholder

renderTextProgramAlways :: Context -> Int -> (TextNotation,String) -> Renderer
renderTextProgramAlways c z (TidalTextNotation _,_) = renderControlPattern c z
renderTextProgramAlways c z (Punctual,s) = return () -- placeholder


renderControlPattern :: Context -> Int -> Renderer
renderControlPattern c z = do
  s <- get
  let controlPattern = IntMap.lookup z $ paramPatterns s -- :: Maybe ControlPattern
  let lt = logicalTime s
  let tempo' = tempo c
  let ps = paramPatterns s
  let events = maybe [] id $ fmap (renderTidalPattern lt renderPeriod tempo') controlPattern
  modify' $ \x -> x { dirtEvents = (dirtEvents s) ++ events }


runRender :: MVar Context -> MVar RenderInfo -> Renderer
runRender c ri = do
  t1 <- liftIO $ getCurrentTime
  modify' $ \x -> x { renderStartTime = t1 }
  c' <- liftIO $ readMVar c
  render c'
  t2 <- liftIO $ getCurrentTime
  modify' $ \x -> x { renderEndTime = t2 }
  calculateRenderTimes
  ri' <- gets info -- RenderInfo from the state maintained by this iteration...
  liftIO $ swapMVar ri ri' -- ...is copied to an MVar so it can be read elsewhere.
  sleepUntilNextRender

sleepUntilNextRender :: Renderer
sleepUntilNextRender = do
  s <- get
  let next = addUTCTime renderPeriod (logicalTime s)
  let diff = diffUTCTime next (renderEndTime s)
  next' <- liftIO $ if diff > 0 then return next else do
    putStrLn "*** logical time too far behind clock time - fast forwarding"
    return $ addUTCTime (diff * (-1) + 0.01) next -- fast forward so next logical time is 10 milliseconds after clock time
  let diff' = diffUTCTime next' (renderEndTime s)
  next'' <- liftIO $ if diff' < (renderPeriod*2) then return next' else do -- not allowed to get more than 1 render period ahead
    putStrLn "*** logical time too far ahead of clock time - rewinding"
    return $ addUTCTime renderPeriod $ renderEndTime s
  let diff'' = diffUTCTime next'' (renderEndTime s)
  let delay = floor $ realToFrac diff'' * 1000000 - 10000 -- ie. wakeup ~ 10 milliseconds before next logical time
  liftIO $ threadDelay delay
  put $ s { logicalTime = next'' }

calculateRenderTimes :: Renderer
calculateRenderTimes = do
  s <- get
  --
  let renderTime = diffUTCTime (renderEndTime s) (renderStartTime s)
  let newRenderTimes = take 20 $ renderTime:(renderTimes s)
  let newAvgRenderTime = sum newRenderTimes / (fromIntegral $ length newRenderTimes)
  let newPeakRenderTime = maximum newRenderTimes
  let newAvgRenderLoad = ceiling (newAvgRenderTime * 100 / renderPeriod)
  let newPeakRenderLoad = ceiling (newPeakRenderTime * 100 / renderPeriod)
  modify' $ \x -> x { renderTimes = newRenderTimes }
  modify' $ \x -> x { info = (info x) { avgRenderLoad = newAvgRenderLoad }}
  modify' $ \x -> x { info = (info x) { peakRenderLoad = newPeakRenderLoad }}

forkRenderThread :: MVar Context -> MVar RenderInfo -> IO ()
forkRenderThread c ri = do
  renderStart <- getCurrentTime
  void $ forkIO $ iterateM_ (execStateT $ runRender c ri) (initialRenderState renderStart)
