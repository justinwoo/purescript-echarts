module ECharts.Color (
  Color(..),
  ColorFuncParamRec(),
  ColorFuncParam(..),
  CalculableColor(..)
  ) where

import Data.Function
import Data.Argonaut.Core
import Data.Argonaut.Encode

import ECharts.Item.Value
import ECharts.Utils

type Color = String

foreign import func2json """
function func2json(fn) {
  return fn;
}
""" :: forall a. a -> Json

type ColorFuncParamRec = {
    "seriesIndex" :: Number,
    "series" :: String,
    "dataIndex" :: Number,
    "data" :: {
      value :: ItemValue,
      name :: String
      }
  }

newtype ColorFuncParam = ColorFuncParam ColorFuncParamRec



data CalculableColor = SimpleColor Color | ColorFunc (ColorFuncParam -> Color)
instance calculableColorEncodeJson :: EncodeJson CalculableColor where
  encodeJson cc = case cc of
    SimpleColor color -> encodeJson color
    ColorFunc func -> func2json $ mkFn1 func
