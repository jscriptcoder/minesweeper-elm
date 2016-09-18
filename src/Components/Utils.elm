module Components.Utils exposing (toInt)

import String
import Result


toInt : String -> Int
toInt strNum =
    strNum
        |> String.toInt
        |> Result.withDefault 0
