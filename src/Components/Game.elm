module Components.Game exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.App as App

import Components.Config as Config
import Components.Dialog as Dialog
import Components.Board as Board



-- MESSAGES

type Msg
    = DialogMsg Dialog.Msg
    | BoardMsg Board.Msg



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
        [ App.map DialogMsg <| Dialog.view model.dialog
        , App.map BoardMsg <| Board.view model.board
        ]



-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        DialogMsg dialogMsg ->
            let
                ( dialogModel 
                , dialogOutMsg
                ) = Dialog.update dialogMsg model.dialog
            in
                (processDialogOutMsg dialogOutMsg model dialogModel, Cmd.none)

        BoardMsg boardMsg ->
            let
                ( boardModel
                , boardOutMsg
                ) = Board.update boardMsg model.board
            in
                (processBoardOutMsg boardOutMsg model boardModel, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Helpers

processDialogOutMsg : Maybe Dialog.OutMsg -> Model -> Dialog.Model -> Model
processDialogOutMsg dialogOutMsg model dialogModel =
    case dialogOutMsg of
        Just Dialog.SaveCustomLevel ->
            { model |
                config = Config.customLevel
                            model.config
                            dialogModel.mines
                            dialogModel.rows
                            dialogModel.columns,
                dialog = dialogModel
            }

        Nothing ->
            { model | dialog = dialogModel }

processBoardOutMsg : Maybe Board.OutMsg -> Model -> Board.Model -> Model
processBoardOutMsg boardOutMsg model boardModel =
    case boardOutMsg of
        Just Board.OpenCustomDialog ->
            { model |
                dialog = Dialog.toggleOpen model.dialog,
                board = boardModel
            }

        Nothing ->
            { model | board = boardModel }