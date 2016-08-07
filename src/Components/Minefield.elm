module Minefield exposing (view)

import Html exposing (div)
import Html.Attributes exposing (class)
import List exposing (repeat)
import Cell



-- VIEW

view model =
    div [ class "minefield" ] 
        <| generateField model.rows model.columns

generateField rows columns =
    repeat rows 
        <| div [ class "row" ] 
        <| repeat columns 
        <| Cell.view Cell.model