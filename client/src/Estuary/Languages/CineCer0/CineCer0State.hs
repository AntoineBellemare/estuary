{-# LANGUAGE JavaScriptFFI, OverloadedStrings #-}

module Estuary.Languages.CineCer0.CineCer0State where

import Data.Text (Text)
import qualified Data.Text as T
import GHCJS.Types
import GHCJS.DOM.Types (HTMLDivElement)
import GHCJS.Marshal.Pure
import Data.IntMap.Strict as IntMap
import Data.Time
import TextShow

import Estuary.Types.Tempo
import Estuary.Languages.CineCer0.Parser
import Estuary.Languages.CineCer0.VideoSpec

newtype CineCer0Video = CineCer0Video { videoJSVal :: JSVal }

instance PToJSVal CineCer0Video where pToJSVal (CineCer0Video val) = val

instance PFromJSVal CineCer0Video where pFromJSVal = CineCer0Video

foreign import javascript safe
  "var video = document.createElement('video'); video.setAttribute('src',$1); $r=video"
  makeVideo :: Text -> IO CineCer0Video

foreign import javascript safe
  "$2.appendChild($1); $1.play();"
  appendVideo :: CineCer0Video -> HTMLDivElement -> IO ()

foreign import javascript safe
  "$1.removeChild($2)"
  removeVideo :: HTMLDivElement -> CineCer0Video -> IO ()

foreign import javascript safe
  "$1.style = $2;"
  videoGeometry_ :: CineCer0Video -> Text -> IO ()

foreign import javascript unsafe
  "$1.muted = true;"
  muteVideo :: CineCer0Video -> IO ()

videoGeometry :: CineCer0Video -> Int -> Int -> Int -> Int -> IO ()
videoGeometry v x y w h = videoGeometry_ v $ "left: " <> showt x <> "%; top: " <> showt y <> "%; position: absolute; width:" <> showt w <> "%; height:" <> "%;"


addVideo :: HTMLDivElement -> VideoSpec -> IO CineCer0Video
addVideo j spec = do
  let url = T.pack $ sampleVideo spec
  x <- makeVideo url
  muteVideo x
  appendVideo x j
  return x

updateCineCer0State :: Tempo -> UTCTime -> CineCer0Spec -> CineCer0State -> IO CineCer0State
updateCineCer0State t now spec st = do
  -- add or delete videos
  let newVideoSpecs = difference spec (videos st) -- :: IntMap VideoSpec
  let toAdd = IntMap.filter (\x -> sampleVideo x /= "") newVideoSpecs
  addedVideos <- mapM (addVideo $ videoDiv st) toAdd -- :: IntMap CineCer0Video
  let videosWithRemovedSpecs = difference (videos st) spec -- :: IntMap CineCer0Video
  let videosWithEmptySource = intersection (videos st) $ IntMap.filter (\x -> sampleVideo x == "") spec -- :: IntMap CineCer0Video
  let toDelete = union videosWithRemovedSpecs videosWithEmptySource
  mapM (removeVideo $ videoDiv st) toDelete
  let videosThereBefore = difference (videos st) toDelete -- :: IntMap CineCer0Video
  let continuingVideos = union videosThereBefore addedVideos -- :: IntMap CineCer0Video
  sequence $ intersectionWith (updateContinuingVideo t now) spec continuingVideos
  return $ st { videos = continuingVideos }

updateContinuingVideo :: Tempo -> UTCTime -> VideoSpec -> CineCer0Video -> IO ()
updateContinuingVideo t now s v = do
  let fitWidth = 100
  let fitHeight = 100
  let actualWidth = floor $ width s * fitWidth
  let actualHeight = floor $ height s * fitHeight
  videoGeometry v (floor $ posX s) (floor $ posY s) actualWidth actualHeight
  -- *** also needs to query position in time of the video
  -- and set position in time of the video if necessary
  -- or maybe do other things, like...
  -- let lengthOfVideo = ?
  -- let newPos = playbackPosition s t lengthOfVideo now -- :: Maybe NominalDiffTime
  -- let newRate = playbackRate s t lengthOfVideo now -- :: Maybe Rational
  -- then... maybe set newPos and newRate if necessary?

emptyCineCer0State :: HTMLDivElement -> CineCer0State
emptyCineCer0State j = CineCer0State {
  videoDiv = j,
  videos = empty
  }

data CineCer0State = CineCer0State {
  videoDiv :: HTMLDivElement,
  videos :: IntMap CineCer0Video
  }
