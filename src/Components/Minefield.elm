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
import Components.Config as Config
import Components.Cell as Cell


-- MESSAGES


type Msg
    = CellMsg Cell.Msg



-- MODEL


type alias Model =
    List (List Cell.Model)


type alias Grid =
    Model


type alias Matrix =
    Array (Array Cell.Model)


model : Model
model =
    create Config.model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "minefield" ] <| List.map viewRowCells model


viewRowCells : List Cell.Model -> Html Msg
viewRowCells cells =
    div [ class "row" ] <| List.map viewCell cells


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
        newGrid =
            List.map
                (\column ->
                    List.map
                        (\cell ->
                            if cell.id == newCell.id then
                                newCell
                            else
                                cell
                        )
                        column
                )
                model

        isEmptyCell =
            newCell.state == Cell.Opened && newCell.value == 0
    in
        if isEmptyCell then
            openEmptyNeighbors newGrid newCell
        else
            newGrid



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
            List.repeat len Cell.model

        ids =
            [1..len]

        cellsWithId =
            List.map2 (\id cell -> { cell | id = id }) ids cells

        cellsWithMines =
            List.map
                (\cell ->
                    if List.member cell.id randomMines then
                        { cell | mine = True }
                    else
                        cell
                )
                cellsWithId

        grid =
            list2Grid (List.reverse cellsWithMines) columns
    in
        findCellsValueAndLocation grid


list2Grid : List Cell.Model -> Int -> Grid
list2Grid cells columns =
    list2GridHelper cells columns []


list2GridHelper : List Cell.Model -> Int -> Grid -> Grid
list2GridHelper cells columns grid =
    let
        cellsColumn =
            List.take columns cells
    in
        if List.length cellsColumn > 0 then
            let
                newCells =
                    List.drop columns cells

                reverseColumn =
                    List.reverse cellsColumn

                newGrid =
                    reverseColumn :: grid
            in
                list2GridHelper newCells columns newGrid
        else
            grid


findCellsValueAndLocation : Grid -> Grid
findCellsValueAndLocation grid =
    let
        matrix =
            grid2Matrix grid

        matrixWithValues =
            Array.indexedMap
                (\column cells ->
                    Array.indexedMap
                        (\row cell ->
                            if cell.mine then
                                cell
                            else
                                { cell
                                    | value = findValue column row matrix
                                    , col = column
                                    , row = row
                                }
                        )
                        cells
                )
                matrix

        gridWithValues =
            matrix2Grid matrixWithValues
    in
        gridWithValues


grid2Matrix : Grid -> Matrix
grid2Matrix grid =
    Array.fromList (List.map (\column -> Array.fromList column) grid)


matrix2Grid : Matrix -> Grid
matrix2Grid matrix =
    Array.toList (Array.map (\column -> Array.toList column) matrix)


findValue : Int -> Int -> Matrix -> Int
findValue column row matrix =
    let
        maybeTopLeft =
            get (column - 1) matrix `andThen` get (row - 1)

        maybeTop =
            get column matrix `andThen` get (row - 1)

        maybeTopRight =
            get (column + 1) matrix `andThen` get (row - 1)

        maybeLeft =
            get (column - 1) matrix `andThen` get row

        maybeRight =
            get (column + 1) matrix `andThen` get row

        maybeBottomLeft =
            get (column - 1) matrix `andThen` get (row + 1)

        maybeBottom =
            get column matrix `andThen` get (row + 1)

        maybeBottomRight =
            get (column + 1) matrix `andThen` get (row + 1)

        emptyCell =
            Cell.model

        pointPerMineList =
            List.map
                (\cell ->
                    if cell.mine then
                        1
                    else
                        0
                )
                [ withDefault emptyCell maybeTopLeft
                , withDefault emptyCell maybeTop
                , withDefault emptyCell maybeTopRight
                , withDefault emptyCell maybeLeft
                , withDefault emptyCell maybeRight
                , withDefault emptyCell maybeBottomLeft
                , withDefault emptyCell maybeBottom
                , withDefault emptyCell maybeBottomRight
                ]
    in
        List.foldl (+) 0 pointPerMineList


openEmptyNeighbors : Grid -> Cell.Model -> Grid
openEmptyNeighbors grid newCell =
    List.map
        (\cells ->
            List.map
                (\cell ->
                    if canOpenCell cell newCell then
                        { cell | state = Cell.Opened }
                    else
                        cell
                )
                cells
        )
        grid


openEmptyNeighborsHelper : Grid -> Cell.Model -> List Cell.Model -> Grid
openEmptyNeighborsHelper grid cellRef neighbors =
    if List.length neighbors > 0 then
        grid
    else
        grid


canOpenCell : Cell.Model -> Cell.Model -> Bool
canOpenCell cell cellRef =
    let
        isNeighbor =
            isNeighborCell cell cellRef

        isNotMine =
            not cell.mine

        hasNoValue =
            cell.value == 0
    in
        isNeighbor && isNotMine && hasNoValue


isNeighborCell : Cell.Model -> Cell.Model -> Bool
isNeighborCell cell cellRef =
    cell.col
        >= (cellRef.col - 1)
        && cell.col
        <= (cellRef.col + 1)
        && cell.row
        >= (cellRef.row - 1)
        && cell.row
        <= (cellRef.row + 1)
