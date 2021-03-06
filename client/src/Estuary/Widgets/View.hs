{-# LANGUAGE OverloadedStrings #-}

module Estuary.Widgets.View where

import Reflex
import Reflex.Dom
import qualified Data.IntMap.Strict as IntMap
import qualified Data.Map.Strict as Map
import Control.Monad
import Data.Maybe

import Estuary.Types.Live
import Estuary.Types.Definition
import Estuary.Types.View
import Estuary.Types.EnsembleC
import Estuary.Types.Ensemble
import Estuary.Types.Context
import Estuary.Tidal.Types
import Estuary.Types.TextNotation
import Estuary.Types.TidalParser
import Estuary.Types.RenderInfo
import Estuary.Widgets.Editor
import Estuary.Types.Variable
import Estuary.Widgets.Text
import Estuary.Widgets.TransformedPattern
import Estuary.Widgets.Sequencer
import Estuary.Types.EnsembleRequest
import Estuary.Types.EnsembleResponse


viewWidget :: MonadWidget t m => Event t [EnsembleResponse] -> View -> Editor t m (Event t EnsembleRequest)

-- viewWidget er (RowView p v) = do
---  let nRows = viewToRows v
--   some kind of div where the default font-size is set from the number of rows and percentage (p)
--   and has to contain the embedded view... so...
--   let style = ... -- dynamic style
--   let attrs = ... -- dynamic map of div attributes
--   elDynAttrs "div" attrs $ viewWidget er v

-- viewWidget er (CellView p v) = do
--   similar to RowView where the horizontal width comes from the from percentage (p)

viewWidget er (LabelView z) = zoneWidget z "" maybeLabelText LabelText er labelEditor

viewWidget er (StructureView z) = zoneWidget z EmptyTransformedPattern maybeStructure Structure er structureEditor

viewWidget er (TextView z rows) = do
  ri <- askRenderInfo
  let errorDyn = fmap (IntMap.lookup z . errors) ri
  zoneWidget z (Live (TidalTextNotation MiniTidal,"") L3) maybeTextProgram TextProgram er (textProgramEditor rows errorDyn)

viewWidget er (SequenceView z) = zoneWidget z defaultValue maybeSequence Sequence er sequencer
  where defaultValue = Map.singleton 0 ("",replicate 8 False)

viewWidget er (ViewDiv c v) = liftR2 (divClass c) $ viewWidget er v

viewWidget er (Views xs) = liftM leftmost $ mapM (viewWidget er) xs

viewWidget _ _ = return never


zoneWidget :: (MonadWidget t m, Eq a)
  => Int -> a -> (Definition -> Maybe a) -> (a -> Definition) -> Event t [EnsembleResponse]
  -> (Dynamic t a -> Editor t m (Variable t a))
  -> Editor t m (Event t EnsembleRequest)
zoneWidget z defaultA f g ensResponses anEditorWidget = do
  ctx <- askContext
  iCtx <- initialValueOfDyn ctx
  let iDef = IntMap.findWithDefault (g defaultA) z $ zones $ ensemble $ ensembleC iCtx
  let iValue = maybe defaultA id $ f iDef
  let deltas = fmapMaybe (join . fmap f . listToMaybe . reverse . justEditsInZone z) ensResponses -- :: Event t a
  dynUpdates <- liftR $ holdDyn iValue deltas
  variableFromWidget <- anEditorWidget dynUpdates
  return $ (WriteZone z . g) <$> localEdits variableFromWidget
