module Components.Utils
    exposing
        ( toInt
        , onRightClick
        , grid2Matrix
        , matrix2Grid
        , sanitizeMaybeList
        )

import String
import Result
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import Json.Decode exposing (succeed)
import List exposing (..)
import Array exposing (..)


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


grid2Matrix : List (List a) -> Array (Array a)
grid2Matrix grid =
    Array.fromList (List.map (\column -> Array.fromList column) grid)


matrix2Grid : Array (Array a) -> List (List a)
matrix2Grid matrix =
    Array.toList (Array.map (\column -> Array.toList column) matrix)


sanitizeMaybeList : List (Maybe a) -> List a
sanitizeMaybeList maybeList =
    filterMap identity maybeList
