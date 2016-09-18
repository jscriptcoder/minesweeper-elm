module Components.Minefield exposing (Msg, Model, model, view, create)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List exposing (repeat, length, map)
import Html.App as App
import Components.Config as Config
import Components.Cell as Cell


-- MESSAGES


type Msg
    = CellMsg Cell.Msg



-- MODEL


type alias Model =
    List (List Cell.Model)


model : Model
model =
    create Config.model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "minefield" ] <| map viewRowCells model


viewRowCells : List Cell.Model -> Html Msg
viewRowCells cells =
    div [ class "row" ] <| map viewCell cells


viewCell : Cell.Model -> Html Msg
viewCell cell =
    App.map CellMsg <| Cell.view cell



-- Helpers


create : Config.Model -> List (List Cell.Model)
create config =
    Cell.model
        |> repeat (.columns config)
        |> repeat (.rows config)
