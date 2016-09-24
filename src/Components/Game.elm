module Components.Game exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Html.App as App
import Task exposing (perform)
import Time exposing (now)
import Random exposing (Seed, initialSeed)
import Components.Config as Config
import Components.Dialog as Dialog
import Components.Board as Board
import Components.Menu as Menu
import Components.Header as Header


-- MESSAGES


type Msg
    = NoOp
    | Timestamp Float
    | DialogMsg Dialog.Msg
    | BoardMsg Board.Msg
    | ClickAway



-- MODEL


type alias Model =
    { config : Config.Model
    , dialog : Dialog.Model
    , board : Board.Model
    }


model : Model
model =
    { config = Config.model
    , dialog = Dialog.model
    , board = Board.model
    }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "game-container" ]
        [ viewClickerAway model
        , App.map DialogMsg <| Dialog.view model.dialog
        , App.map BoardMsg <| Board.view model.board model.config
        ]


viewClickerAway : Model -> Html Msg
viewClickerAway model =
    div
        [ classList
            [ ( "clicker-away", True )
            , ( "ready", model.board.menu.open )
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
                config =
                    model.config

                configWithSeed =
                    { config | seed = initialSeed <| round time }

                configWithMines =
                    Config.generateRandomMines configWithSeed
            in
                ( processMenuMsg
                    Menu.NewGame
                    { model | config = configWithMines }
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
                    Board.update boardMsg model.board model.config

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
    Sub.none



-- Helpers


requestTime : Cmd Msg
requestTime =
    perform (\_ -> NoOp) Timestamp now


processDialogMsg : Dialog.Msg -> Model -> Dialog.Model -> Model
processDialogMsg dialogMsg model dialogModel =
    case dialogMsg of
        Dialog.ButtonMsg buttonMsg ->
            if buttonMsg == Dialog.Ok then
                let
                    newConfig =
                        Config.customLevel
                            model.config
                            dialogModel.mines
                            dialogModel.rows
                            dialogModel.columns
                in
                    { model
                        | config = newConfig
                        , board = Board.createMinefield model.board newConfig
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

        _ ->
            model


processMenuMsg : Menu.Msg -> Model -> Model
processMenuMsg menuMsg model =
    case menuMsg of
        Menu.NewGame ->
            let
                newConfig =
                    Config.generateRandomMines model.config
            in
                { model
                    | config = newConfig
                    , board = Board.createMinefield model.board newConfig
                }

        Menu.BeginnerLevel ->
            let
                newConfig =
                    Config.beginnerLevel model.config
            in
                { model
                    | config = newConfig
                    , board = Board.createMinefield model.board newConfig
                }

        Menu.IntermediateLevel ->
            let
                newConfig =
                    Config.intermediateLevel model.config
            in
                { model
                    | config = newConfig
                    , board = Board.createMinefield model.board newConfig
                }

        Menu.ExpertLevel ->
            let
                newConfig =
                    Config.expertLevel model.config
            in
                { model
                    | config = newConfig
                    , board = Board.createMinefield model.board newConfig
                }

        Menu.CustomLevel ->
            { model | dialog = Dialog.toggleOpen model.dialog }

        Menu.CheckMarks ->
            let
                newConfig =
                    Config.toggleMarks model.config
            in
                { model | config = newConfig }
