module Estuary.Types.RenderState where

import Data.Time.Clock
import Data.IntMap.Strict
import qualified Sound.Tidal.Context as Tidal
import qualified Sound.Punctual.PunctualW as Punctual
import qualified Sound.Punctual.WebGL as Punctual
import Sound.MusicW.AudioContext
import GHCJS.DOM.Types

import Estuary.Types.Definition
import Estuary.Types.RenderInfo
import qualified Estuary.Languages.CineCer0.CineCer0State as CineCer0
import qualified Estuary.Languages.CineCer0.Parser as CineCer0
import Estuary.Types.MovingAverage
import Estuary.Types.TextNotation

data RenderState = RenderState {
  wakeTimeAudio :: !Double,
  wakeTimeSystem :: !UTCTime,
  renderStart :: !UTCTime,
  renderPeriod :: !NominalDiffTime,
  renderEnd :: !UTCTime,
  cachedDefs :: !DefinitionMap,
  cachedCanvasElement :: !(Maybe HTMLCanvasElement),
  paramPatterns :: !(IntMap Tidal.ControlPattern),
  dirtEvents :: ![(UTCTime,Tidal.ControlMap)],
  baseNotations :: !(IntMap TextNotation),
  punctuals :: !(IntMap (Punctual.PunctualW AudioContextIO)),
  punctualWebGLs :: !(IntMap Punctual.PunctualWebGL),
  cineCer0Specs :: !(IntMap CineCer0.CineCer0Spec),
  cineCer0States :: !(IntMap CineCer0.CineCer0State),
  renderTime :: !MovingAverage,
  zoneRenderTimes :: !(IntMap MovingAverage),
  zoneAnimationTimes :: !(IntMap MovingAverage),
  info :: !RenderInfo
  }

initialRenderState :: UTCTime -> AudioTime -> IO RenderState
initialRenderState t0System t0Audio = do
  return $ RenderState {
    wakeTimeSystem = t0System,
    wakeTimeAudio = t0Audio,
    renderStart = t0System,
    renderPeriod = 0,
    renderEnd = t0System,
    cachedDefs = empty,
    cachedCanvasElement = Nothing,
    paramPatterns = empty,
    dirtEvents = [],
    baseNotations = empty,
    punctuals = empty,
    punctualWebGLs = empty,
    cineCer0Specs = empty,
    cineCer0States = empty,
    renderTime = newAverage 20,
    zoneRenderTimes = empty,
    zoneAnimationTimes = empty,
    info = emptyRenderInfo
  }
