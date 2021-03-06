{-# LANGUAGE OverloadedStrings #-}

module Estuary.Types.View.Parser (viewsParser,dumpView) where

import Text.Parsec
import Text.Parsec.Text
import qualified Text.ParserCombinators.Parsec.Token as P
import Text.Parsec.Language (haskellDef)
import Data.List (intercalate)
import Data.Text (Text)
import qualified Data.Text as T
import TextShow
import Control.Monad.Identity (Identity)

import Estuary.Types.View

dumpView :: View -> Text
dumpView (Views xs) = T.intercalate " " $ fmap dumpView xs
dumpView (ViewDiv css v) = "{ " <> css <> " " <> dumpView v <> " }"
dumpView (StructureView x) = "structure:" <> showInt x
dumpView (LabelView x) = "label:" <> showInt x
dumpView (TextView x y) = "text:" <> showInt x <> " " <> showInt y
dumpView (SequenceView z) = "sequence:" <> showInt z

showInt :: Int -> Text
showInt x = showtParen (x < 0) (showt x)

topLevelViewsParser :: Parser View
topLevelViewsParser = do
  whiteSpace
  v <- viewsParser
  eof
  return v

viewsParser :: Parser View
viewsParser = Views <$> many1 viewParser

viewParser :: Parser View
viewParser = do
  v <- choice [
    try viewDiv,
    try labelView,
    try structureView,
    try sequenceView,
    textView
    ]
  return v

viewDiv = braces $ (ViewDiv <$> (T.pack <$> identifier) <*> viewsParser)
labelView = reserved "label" >> reservedOp ":" >> (LabelView <$> int)
structureView = reserved "structure" >> reservedOp ":" >> (StructureView <$> int)
sequenceView = reserved "sequence" >> reservedOp ":" >> (SequenceView <$> int)
textView = reserved "text" >> reservedOp ":" >> (TextView <$> int <*> int)

int :: Parser Int
int = choice [
  parens $ (fromIntegral <$> integer),
  fromIntegral <$> integer
  ]

tokenParser :: P.GenTokenParser Text () Identity
tokenParser = P.makeTokenParser $ P.LanguageDef {
  P.commentStart = "{-",
  P.commentEnd = "-}",
  P.commentLine = "--",
  P.nestedComments = False,
  P.identStart = letter <|> char '_',
  P.identLetter = alphaNum <|> char '_',
  P.opStart = oneOf "+*:@<>~=%",
  P.opLetter = oneOf "+*:@<>~=%",
  P.reservedNames = [
    "label","structure","sequenceView","textView","svgDisplayView",
    "canvasDisplayView"
    ],
  P.reservedOpNames = [":"],
  P.caseSensitive = True
  }

identifier = P.identifier tokenParser
reserved = P.reserved tokenParser
operator = P.operator tokenParser
reservedOp = P.reservedOp tokenParser
charLiteral = P.charLiteral tokenParser
stringLiteral = P.stringLiteral tokenParser
natural = P.natural tokenParser
integer = P.integer tokenParser
float = P.float tokenParser
naturalOrFloat = P.naturalOrFloat tokenParser
decimal = P.decimal tokenParser
hexadecimal = P.hexadecimal tokenParser
octal = P.octal tokenParser
symbol = P.symbol tokenParser
lexeme = P.lexeme tokenParser
whiteSpace = P.whiteSpace tokenParser
parens = P.parens tokenParser
braces = P.braces tokenParser
angles = P.angles tokenParser
brackets = P.brackets tokenParser
semi = P.semi tokenParser
comma = P.comma tokenParser
colon = P.colon tokenParser
dot = P.dot tokenParser
semiSep = P.semiSep tokenParser
semiSep1 = P.semiSep1 tokenParser
commaSep = P.commaSep tokenParser
commaSep1 = P.commaSep1 tokenParser
