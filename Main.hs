
module Main where

import Reflex
import Reflex.Dom
import Estuary.Tidal.Types
import Estuary.Reflex.Utility
import Estuary.Widgets.Generic
import Estuary.Widgets.StackedPatterns
import Estuary.Widgets.PatternChain as P
import Control.Monad (liftM)
import qualified Sound.Tidal.Context as Tidal
import Estuary.WebDirt.Foreign
import Estuary.WebDirt.Stream
import Estuary.Page
import Estuary.Widgets.SpecificPattern
import Estuary.Widgets.WebDirt
import Data.Map
import Control.Monad.IO.Class


main :: IO ()
main = do
  wd <- webDirt
  initializeWebAudio wd
  stream <- webDirtStream wd
  mainWidget $ do
    elAttr "img" (fromList $ zip ["src","width","height"] ["logo.png","168","59"]) blank
    startButton <- el "div" $ button "Start"
    --performEvent $ fmap (liftIO . (initializeWebAudio wd)) startButton
    performEvent $ fmap (liftIO . ( const $ initializeWebAudio wd)) startButton
    --webDirtWidget wd
    el "div" $ multipage stream pages


twoStackedPatterns :: MonadWidget t m => m (Dynamic t (StackedPatterns,Event t GenericSignal))
twoStackedPatterns = stackedPatternsWidget (StackedPatterns [EmptyPatternChain,EmptyPatternChain]) never

pages = [
  ("ICLC Text Widget",widgetToPage $ iclcTextWidget EmptyPatternChain never),
  ("ICLC Stacked Patterns Widget",widgetToPage twoStackedPatterns),
  ("ICLC Fixed Widget", widgetToPage $ P.iclcFixedStruct EmptyPatternChain never),
  ("ICOAH", widgetToPage $ P.icoahWidget EmptyPatternChain never)
  ]
