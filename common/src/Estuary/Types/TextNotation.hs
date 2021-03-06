{-# LANGUAGE DeriveGeneric #-}

module Estuary.Types.TextNotation where

import GHC.Generics
import Data.Aeson

import Estuary.Types.TidalParser

data TextNotation =
  TidalTextNotation TidalParser |
  Punctual |
  CineCer0 |
  TimeNot |
  Experiment
  deriving (Read,Eq,Ord,Show,Generic)

instance ToJSON TextNotation where
  toEncoding = genericToEncoding defaultOptions
instance FromJSON TextNotation

textNotationDropDownLabel :: TextNotation -> String
textNotationDropDownLabel (TidalTextNotation x) = show x
textNotationDropDownLabel x = show x
