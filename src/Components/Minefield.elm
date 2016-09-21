module Components.Minefield
    exposing
        ( Msg
        , Model
        , model
        , view
        , update
        , create
        )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List exposing (..)
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



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        CellMsg cellMsg ->
            let
                newCell =
                    Cell.update cellMsg
            in
                map
                    (\column ->
                        map
                            (\cell ->
                                if cell.id == newCell.id then
                                    newCell
                                else
                                    cell
                            )
                            column
                    )
                    model



-- Helpers


create : Config.Model -> Model
create config =
    let
        columns =
            config.columns

        rows =
            config.rows

        len =
            columns * rows

        randomMines =
            config.randomMines

        cells =
            repeat len Cell.model

        ids =
            [1..len]

        cellsWithId =
            map2 (\id cell -> { cell | id = id }) ids cells

        cellsWithMines =
            map
                (\cell ->
                    if member cell.id randomMines then
                        { cell | mine = True }
                    else
                        cell
                )
                cellsWithId
    in
        list2Matrix (reverse cellsWithMines) columns


list2Matrix : List Cell.Model -> Int -> Model
list2Matrix cells columns =
    list2MatrixHelper cells columns []


list2MatrixHelper : List Cell.Model -> Int -> Model -> Model
list2MatrixHelper cells columns matrix =
    let
        cellsColumn =
            take columns cells
    in
        if length cellsColumn > 0 then
            let
                newCells =
                    drop columns cells

                reverseColumn =
                    reverse cellsColumn

                newMatrix =
                    reverseColumn :: matrix
            in
                list2MatrixHelper newCells columns newMatrix
        else
            matrix
