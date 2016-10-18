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
import Maybe exposing (withDefault, andThen)
import Html.App as App
import Matrix exposing (..)
import Components.Global as Global
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
    create Global.model



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
                openEmptyNeighbors newCell newModel

            _ ->
                newModel



-- Helpers


create : Global.Model -> Grid
create global =
    let
        rows =
            global.rows

        columns =
            global.columns

        width =
            columns

        len =
            rows * columns

        randomMines =
            global.randomMines

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


openEmptyNeighbors : Cell.Model -> Grid -> Grid
openEmptyNeighbors newCell grid =
    if Cell.isEmpty newCell then
        let
            qualifiedNeighbors =
                findQualifiedNeighbors
                    newCell.loc
                    grid

            newGrid =
                List.foldl openCell grid qualifiedNeighbors
        in
            openEmptyNeighborsHelper
                (head qualifiedNeighbors)
                (tail qualifiedNeighbors)
                newGrid
    else
        grid


openEmptyNeighborsHelper : Maybe Cell.Model -> Maybe (List Cell.Model) -> Grid -> Grid
openEmptyNeighborsHelper maybeCell maybeNeighbors grid =
    case maybeCell of
        Just cell ->
            let
                newGrid =
                    openEmptyNeighbors cell grid
            in
                case maybeNeighbors of
                    Just neighbors ->
                        openEmptyNeighborsHelper
                            (head neighbors)
                            (tail neighbors)
                            newGrid

                    Nothing ->
                        newGrid

        Nothing ->
            grid


findQualifiedNeighbors : Location -> Grid -> List Cell.Model
findQualifiedNeighbors loc grid =
    let
        neighbors =
            findNeighbors loc grid
    in
        List.filter (\cell -> Cell.canOpen cell) neighbors


openCell : Cell.Model -> Grid -> Grid
openCell cell grid =
    Matrix.set
        cell.loc
        { cell | state = Cell.Opened }
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
