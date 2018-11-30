{-# LANGUAGE RecursiveDo, JavaScriptFFI #-}

module Estuary.Widgets.CanvasDisplay (canvasDisplay) where

import Reflex
import Reflex.Dom
import GHCJS.DOM.Types (HTMLCanvasElement,castToHTMLCanvasElement)
import GHCJS.Types (JSVal)
import Data.JSString
import Data.Map
import Data.List
import Control.Monad
import Control.Monad.Trans
import Control.Concurrent.MVar
import Data.Time.Clock

import Estuary.Types.Color
import Estuary.Types.CanvasOp
import Estuary.RenderInfo

canvasDisplay :: MonadWidget t m => Int -> Dynamic t Context -> m ()
canvasDisplay z = do
  let attrs = fromList [("class","canvasDisplay"),("style","z-index:" ++ show z),("width","1920"),("height","1080")]
  cvs <- liftM (castToHTMLCanvasElement .  _el_element . fst) $ elAttr' "canvas" attrs $ return ()
  ctx <- liftIO $ getContext cvs
  liftIO $ requestAnimationFrame ctx mv

addCanvasOps :: MVar [(UTCTime,CanvasOp)] -> [(UTCTime,CanvasOp)] -> IO ()
addCanvasOps mv newEvents = takeMVar mv >>= (putMVar mv . (++ newEvents))

redrawCanvas :: JSVal -> MVar [(UTCTime,CanvasOp)] -> JSVal -> IO ()
redrawCanvas ctx mv _ = do
  modifyMVar_ mv $ flushCanvasOps ctx
  requestAnimationFrame ctx mv

requestAnimationFrame :: JSVal -> MVar [(UTCTime,CanvasOp)] -> IO ()
requestAnimationFrame ctx mv = do
  cb <- syncCallback1 ContinueAsync $ redrawCanvas ctx mv
  requestAnimationFrame_ cb

flushCanvasOps :: JSVal -> [(UTCTime,CanvasOp)] -> IO [(UTCTime,CanvasOp)]
flushCanvasOps ctx ops = do
  now <- getCurrentTime
  let (opsForNow,opsForLater) = partition ((<= now) . fst) ops
  performCanvasOps ctx opsForNow
  return opsForLater

performCanvasOps :: JSVal -> [(UTCTime,CanvasOp)] -> IO ()
performCanvasOps ctx ops = mapM_ (canvasOp ctx) $ fmap (toActualWandH 1920 1080 . snd) ops

canvasOp :: JSVal -> CanvasOp -> IO ()
canvasOp ctx (Clear a) = do
  fillStyle ctx (pack $ show $ RGBA 0 0 0 a)
  strokeStyle ctx (pack $ show $ RGBA 0 0 0 a)
  rect ctx 0 0 1920 1080
  stroke ctx
  fill ctx
canvasOp ctx (Rect x y w h) = beginPath ctx >> rect ctx x y w h >> stroke ctx >> fill ctx
canvasOp ctx (MoveTo x y) = moveTo ctx x y
canvasOp ctx (LineTo x y) = beginPath ctx >> lineTo ctx x y >> stroke ctx >> fill ctx
canvasOp ctx (StrokeStyle c) = strokeStyle ctx (pack $ show c)
canvasOp ctx (FillStyle c) = fillStyle ctx (pack $ show c)

foreign import javascript safe
  "$r=$1.getContext('2d')"
  getContext :: HTMLCanvasElement -> IO JSVal

foreign import javascript safe
  "$1.beginPath()"
  beginPath :: JSVal -> IO ()

foreign import javascript safe
  "$1.stroke()"
  stroke :: JSVal -> IO ()

foreign import javascript safe
  "$1.fill()"
  fill :: JSVal -> IO ()

foreign import javascript safe
  "$1.strokeStyle = $2"
  strokeStyle :: JSVal -> JSString -> IO ()

foreign import javascript safe
  "$1.fillStyle = $2"
  fillStyle :: JSVal -> JSString -> IO ()

foreign import javascript safe
  "$1.rect($2,$3,$4,$5)"
  rect :: JSVal -> Double -> Double -> Double -> Double -> IO ()

foreign import javascript safe
  "$1.moveTo($2,$3)"
  moveTo :: JSVal -> Double -> Double -> IO ()

foreign import javascript safe
  "$1.lineTo($2,$3)"
  lineTo :: JSVal -> Double -> Double -> IO ()

foreign import javascript safe
  "window.requestAnimationFrame($1)"
  requestAnimationFrame_ :: JSVal -> IO ()
