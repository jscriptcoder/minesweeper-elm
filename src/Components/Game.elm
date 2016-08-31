module Components.Game exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Html.App as App

import Components.Config as Config
import Components.Dialog as Dialog
import Components.Board as Board
import Components.Menu as Menu



-- MESSAGES

type Msg
    = DialogMsg Dialog.Msg
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
    div [ classList
        [ ("clicker-away", True)
        , ("ready", model.board.menu.open)
        ], onClick ClickAway ] []

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        DialogMsg dialogMsg ->
            let
                ( dialogModel 
                , dialogOutMsg
                ) = Dialog.update dialogMsg model.dialog

                newModel = { model | dialog = dialogModel }
            in
                (processDialogOutMsg dialogOutMsg newModel dialogModel, Cmd.none)

        BoardMsg boardMsg ->
            let
                ( boardModel
                , boardOutMsg
                ) = Board.update boardMsg model.board

                newModel = { model | board = boardModel }
            in
                (processBoardOutMsg boardOutMsg newModel boardModel, Cmd.none)

        ClickAway ->
            update (BoardMsg Board.ToggleMenu) model



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Helpers

processDialogOutMsg : Maybe Dialog.OutMsg -> Model -> Dialog.Model -> Model
processDialogOutMsg dialogOutMsg model dialogModel =
    case dialogOutMsg of
        Just Dialog.SaveCustomLevel ->
            let newConfig = Config.customLevel
                                model.config
                                dialogModel.mines
                                dialogModel.rows
                                dialogModel.columns
            in
                { model | 
                    config = newConfig,
                    board = Board.createMinefield model.board newConfig
                }

        Nothing -> model

processBoardOutMsg : Maybe Board.OutMsg -> Model -> Board.Model -> Model
processBoardOutMsg boardOutMsg model boardModel =
    case boardOutMsg of
        Just (Board.MenuOutMsg menuMsg) ->
            processMenuOutMsg menuMsg model boardModel

        Nothing -> model

processMenuOutMsg : Menu.Msg -> Model -> Board.Model -> Model
processMenuOutMsg menuOutMsg model boardModel =
    case menuOutMsg of
        Menu.NewGame ->
            { model | board = Board.createMinefield model.board model.config }

        Menu.BeginnerLevel ->
            let newConfig = Config.beginnerLevel model.config
            in
                { model | 
                    config = newConfig,
                    board = Board.createMinefield model.board newConfig
                }

        Menu.IntermediateLevel ->
            let newConfig = Config.intermediateLevel model.config
            in
                { model | 
                    config = newConfig,
                    board = Board.createMinefield model.board newConfig
                }

        Menu.ExpertLevel ->
            let newConfig = Config.expertLevel model.config
            in
                { model | 
                    config = newConfig,
                    board = Board.createMinefield model.board newConfig
                }

        Menu.CustomLevel ->
            { model | dialog = Dialog.toggleOpen model.dialog }

        Menu.CheckMarks -> model