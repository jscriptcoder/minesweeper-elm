module Components.Utils exposing (toInt, onRightClick)

import String
import Result
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode exposing (succeed)


toInt : String -> Int
toInt strNum =
    strNum
        |> String.toInt
        |> Result.withDefault 0


onRightClick : msg -> Attribute msg
onRightClick msg =
    succeed msg
        |> onWithOptions
            "contextmenu"
            { stopPropagation = True
            , preventDefault = True
            }
