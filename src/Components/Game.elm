module Components.Game exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Html.App as App
import Task exposing (perform)
import Time exposing (now)
import Random exposing (Seed, initialSeed)
import Components.Global as Global
import Components.Dialog as Dialog
import Components.Board as Board
import Components.Menu as Menu
import Components.Header as Header
import Components.Minefield as Minefield
import Components.Cell as Cell


-- MESSAGES


type Msg
    = NoOp
    | Timestamp Float
    | DialogMsg Dialog.Msg
    | BoardMsg Board.Msg
    | ClickAway



-- MODEL


type alias Model =
    { global : Global.Model
    , dialog : Dialog.Model
    , board : Board.Model
    }


model : Model
model =
    { global = Global.model
    , dialog = Dialog.model
    , board = Board.model
    }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "game-container" ]
        [ viewClickerAway model
        , App.map DialogMsg <| Dialog.view model.dialog
        , App.map BoardMsg <| Board.view model.board model.global
        ]


viewClickerAway : Model -> Html Msg
viewClickerAway model =
    div
        [ classList
            [ ( "clicker-away", True )
            , ( "active", model.board.menu.open )
            ]
        , onClick ClickAway
        ]
        []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Timestamp time ->
            let
                global =
                    model.global

                globalWithSeed =
                    { global | seed = initialSeed <| round time }
            in
                ( processMenuMsg
                    Menu.NewGame
                    { model | global = globalWithSeed }
                , Cmd.none
                )

        DialogMsg dialogMsg ->
            let
                dialogModel =
                    Dialog.update dialogMsg model.dialog

                newModel =
                    { model | dialog = dialogModel }
            in
                ( processDialogMsg dialogMsg newModel dialogModel, Cmd.none )

        BoardMsg boardMsg ->
            let
                boardModel =
                    Board.update boardMsg model.board model.global

                newModel =
                    { model | board = boardModel }
            in
                ( processBoardMsg boardMsg newModel, Cmd.none )

        ClickAway ->
            if model.board.menu.open then
                update (BoardMsg Board.ToggleMenu) model
            else
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        board =
            model.board

        global =
            model.global
    in
        Sub.map BoardMsg <| Board.subscriptions board global



-- Helpers


init : ( Model, Cmd Msg )
init =
    ( model, requestTime )


requestTime : Cmd Msg
requestTime =
    perform (\_ -> NoOp) Timestamp now


processDialogMsg : Dialog.Msg -> Model -> Dialog.Model -> Model
processDialogMsg dialogMsg model dialogModel =
    case dialogMsg of
        Dialog.ButtonMsg buttonMsg ->
            if buttonMsg == Dialog.SaveCustom then
                let
                    newGlobal =
                        Global.customLevel
                            model.global
                            dialogModel.mines
                            dialogModel.rows
                            dialogModel.columns
                in
                    { model
                        | global = newGlobal
                        , board = Board.createMinefield model.board newGlobal
                    }
            else
                model

        _ ->
            model


processBoardMsg : Board.Msg -> Model -> Model
processBoardMsg boardMsg model =
    case boardMsg of
        Board.MenuMsg menuMsg ->
            processMenuMsg menuMsg model

        Board.HeaderMsg headerMsg ->
            if headerMsg == Header.ResetGame then
                processMenuMsg Menu.NewGame model
            else
                model

        Board.MinefieldMsg minefieldMsg ->
            processMinefieldMsg minefieldMsg model

        _ ->
            model


processMenuMsg : Menu.Msg -> Model -> Model
processMenuMsg menuMsg model =
    case menuMsg of
        Menu.NewGame ->
            let
                newGlobal =
                    Global.init model.global
            in
                { model
                    | global = newGlobal
                    , board = Board.createMinefield model.board newGlobal
                }

        Menu.BeginnerLevel ->
            let
                newGlobal =
                    Global.beginnerLevel model.global
            in
                { model
                    | global = newGlobal
                    , board = Board.createMinefield model.board newGlobal
                }

        Menu.IntermediateLevel ->
            let
                newGlobal =
                    Global.intermediateLevel model.global
            in
                { model
                    | global = newGlobal
                    , board = Board.createMinefield model.board newGlobal
                }

        Menu.ExpertLevel ->
            let
                newGlobal =
                    Global.expertLevel model.global
            in
                { model
                    | global = newGlobal
                    , board = Board.createMinefield model.board newGlobal
                }

        Menu.CustomLevel ->
            { model | dialog = Dialog.toggleOpen model.dialog }

        Menu.CheckMarks ->
            let
                newGlobal =
                    Global.toggleMarks model.global
            in
                { model | global = newGlobal }


processMinefieldMsg : Minefield.Msg -> Model -> Model
processMinefieldMsg minefieldMsg model =
    case minefieldMsg of
        Minefield.CellMsg cellMsg ->
            case cellMsg of
                Cell.MouseClick cell ->
                    let
                        global =
                            model.global

                        minefield =
                            model.board.minefield

                        isDone =
                            Global.isDone minefield.opened global
                    in
                        if cell.mine || isDone then
                            { model | global = Global.setOver global }
                        else if Global.isReady global.state then
                            { model | global = Global.setStarted global }
                        else
                            model

                _ ->
                    model
