module Utils exposing (onRightClick, toInt)

import String
import Result



type alias onRightClickOptions =
    { stopPropagation : Bool
    , preventDefault : Bool
    }


onRightClick : onRightClickOptions
onRightClick = 
    { stopPropagation : False
    , preventDefault : True
    }



toInt : String -> Int
toInt strNum =
  strNum
    |> String.toInt
    |> Result.withDefault 0