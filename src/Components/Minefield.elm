module Components.Minefield
    exposing
        ( Msg(..)
        , Model
        , model
        , view
        , update
        , create
        )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import List exposing (..)
import Array exposing (..)
import Maybe exposing (withDefault, andThen)
import Html.App as App
import Matrix exposing (..)
import Components.Config as Config
import Components.Cell as Cell
import Components.Utils as Utils


-- MESSAGES


type Msg
    = CellMsg Cell.Msg



-- MODEL


type alias Grid =
    Matrix Cell.Model


type alias Model =
    Grid


model : Model
model =
    create Config.model



-- VIEW


view : Model -> Html Msg
view model =
    Matrix.toList model
        |> List.map viewRowCells
        |> div [ class "minefield" ]


viewRowCells : List Cell.Model -> Html Msg
viewRowCells cells =
    List.map viewCell cells
        |> div [ class "row" ]


viewCell : Cell.Model -> Html Msg
viewCell cell =
    App.map CellMsg <| Cell.view cell



-- UPDATE


update : Msg -> Model -> ( Model, Maybe Cell.Model )
update msg model =
    case msg of
        CellMsg cellMsg ->
            let
                maybeCell =
                    Cell.update cellMsg
            in
                case maybeCell of
                    Just cell ->
                        ( updateGrid cell model, Just cell )

                    Nothing ->
                        ( model, Nothing )


updateGrid : Cell.Model -> Model -> Model
updateGrid newCell model =
    let
        newModel =
            Matrix.set
                newCell.loc
                newCell
                model
    in
        case newCell.state of
            Cell.MineHit ->
                openAllMines newModel

            Cell.Opened ->
                openEmptyNeighbors newModel newCell

            _ ->
                newModel



-- Helpers


create : Config.Model -> Grid
create config =
    let
        rows =
            config.rows

        columns =
            config.columns

        width =
            columns

        len =
            rows * columns

        randomMines =
            config.randomMines

        grid =
            Matrix.matrix
                rows
                columns
                (\loc -> Cell.makeCell width loc randomMines)
    in
        findCellsValue grid


findCellsValue : Grid -> Grid
findCellsValue grid =
    Matrix.map
        (\cell ->
            if not cell.mine then
                { cell | value = findValue cell.loc grid }
            else
                cell
        )
        grid


findValue : Location -> Grid -> Int
findValue location grid =
    let
        neighbors =
            findNeighbors location grid

        pointPerMineList =
            List.map
                (\cell ->
                    if cell.mine then
                        1
                    else
                        0
                )
                neighbors
    in
        List.foldl (+) 0 pointPerMineList


findNeighbors : Location -> Grid -> List Cell.Model
findNeighbors location grid =
    let
        row =
            Matrix.row location

        column =
            Matrix.col location

        maybeTopLeft =
            Matrix.get ( row - 1, column - 1 ) grid

        maybeTop =
            Matrix.get ( row, column - 1 ) grid

        maybeTopRight =
            Matrix.get ( row + 1, column - 1 ) grid

        maybeLeft =
            Matrix.get ( row - 1, column ) grid

        maybeRight =
            Matrix.get ( row + 1, column ) grid

        maybeBottomLeft =
            Matrix.get ( row - 1, column + 1 ) grid

        maybeBottom =
            Matrix.get ( row, column + 1 ) grid

        maybeBottomRight =
            Matrix.get ( row + 1, column + 1 ) grid
    in
        Utils.sanitizeMaybeList
            [ maybeTopLeft
            , maybeTop
            , maybeTopRight
            , maybeLeft
            , maybeRight
            , maybeBottomLeft
            , maybeBottom
            , maybeBottomRight
            ]


findQualifiedNeighbors : Location -> Grid -> List Cell.Model
findQualifiedNeighbors loc grid =
    let
        neighbors =
            findNeighbors loc grid
    in
        List.filter (\cell -> Cell.canOpen cell) neighbors


openEmptyNeighbors : Grid -> Cell.Model -> Grid
openEmptyNeighbors grid newCell =
    if Cell.isEmpty newCell then
        let
            qualifiedNeighbors =
                findQualifiedNeighbors
                    newCell.loc
                    grid

            newGrid =
                Matrix.map
                    (\cell ->
                        if
                            any
                                (\qualifiedCell -> qualifiedCell.id == cell.id)
                                qualifiedNeighbors
                        then
                            { cell | state = Cell.Opened }
                        else
                            cell
                    )
                    grid
        in
            openEmptyNeighborsHelper
                newGrid
                (head qualifiedNeighbors)
                (tail qualifiedNeighbors)
    else
        grid


openEmptyNeighborsHelper grid maybeCell maybeNeighbors =
    case maybeCell of
        Just cell ->
            let
                newGrid =
                    openEmptyNeighbors grid cell
            in
                case maybeNeighbors of
                    Just neighbors ->
                        openEmptyNeighborsHelper newGrid (head neighbors) (tail neighbors)

                    Nothing ->
                        newGrid

        Nothing ->
            grid


openAllMines : Grid -> Grid
openAllMines grid =
    Matrix.map
        (\cell ->
            if Cell.isCoveredMine cell then
                { cell | state = Cell.Mine }
            else
                cell
        )
        grid
