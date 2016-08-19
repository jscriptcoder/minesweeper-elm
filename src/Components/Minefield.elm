module Components.Minefield exposing (Msg, Model, model, view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List exposing (repeat)

import Components.Cell as Cell



-- MESSAGES

type Msg
    = NoOp



-- MODEL

type alias Model =
    { rows : Int
    , columns : Int
    }

model : Model
model = 
    { rows = 9
    , columns = 9
    }



-- VIEW

view : Model -> Html Msg
view model =
    div [ class "minefield" ] 
        <| generateField model.rows model.columns



-- Helpers

generateField : Int -> Int -> Html
generateField rows columns =
    repeat rows
        <| div [ class "row" ]
        <| repeat columns
        <| Cell.view Cell.model