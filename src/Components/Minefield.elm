module Components.Minefield exposing (Msg, Model, model, view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List exposing (repeat, length, map)

import Components.Config as Config
import Components.Cell as Cell



-- MESSAGES

type Msg
    = NoOp



-- MODEL

type alias Model =
    List (List Cell.Model)

model : Model
model =
    Cell.model
        |> repeat (.columns Config.model)
        |> repeat (.rows Config.model)



-- VIEW

view : Model -> Config.Model -> Html Msg
view model config =
    div [ class "minefield" ] 
        <| map viewCells model

viewCells : List Cell.Model -> List (Html Msg)
viewCells cells =
    map Cell.view cells


-- Helpers

