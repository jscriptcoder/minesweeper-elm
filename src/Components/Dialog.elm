module Dialog exposing (Msg, view)

import Html exposing (Html, div, p, label, input, text)
import Html.Attributes exposing (class, classList, type', value)
import Html.Events exposing (onInput, onClick)
import Utils
import Game



-- MESSAGES

type Update
    = UpdateRows String
    | UpdateColumns String
    | UpdateMines String

type Button
    = OK
    | Cancel

type Msg
    = MsgUpdate Update
    | MsgButton Button



-- VIEW

view : Game.Model -> Html Msg
view config, model =
    div [ classList
            [ ("custom-level-dialog", True)
            , ("window-wrapper-outer", True)
            , ("open", model.dialogOpen)
            ]
        ] 
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar"] []
                , div [ class "content" ]
                    [ viewFields config
                    , viewButtons config model
                    ]
                ]
            ]
        ]

viewFields : Game.Config -> Html MsgUpdate
viewFields config =
    div [ class "fields" ]
        [ p []
            [ label [] [ text "Height:"]
            , input [ class "form-textbox custom-height"
                    , type' "text"
                    , value (toString config.rows)
                    , onInput UpdateRows
                    ] []
            ]
        , p []
            [ label [] [ text "Width:"]
            , input [ class "form-textbox custom-width"
                    , type' "text"
                    , value (toString config.columns)
                    , onInput UpdateColumns
                    ] []
            ]
        , p []
            [ label [] [ text "Mines:"]
            , input [ class "form-textbox custom-mines"
                    , type' "text"
                    , value (toString config.mines)
                    , onInput UpdateMines
                    ] []
            ]
        ]

viewButtons : Html MsgButton
viewButtons =
    div [ class "buttons" ]
        [ input [ class "form-button ok-btn"
                , type' "button"
                , value "OK"
                , onClick OK
                ] []
        , input [ class "form-button cancel-btn"
                , type' "button"
                , value "Cancel"
                , onClick Cancel
                ] []
        ]



-- UPDATE

update : Msg -> Game.Config -> Game.Config
update msg config =
    case msg of
        MsgUpdate updates ->
            updateConfig updates config

        MsgButton buttons ->
            updateButton buttons 

updateConfig : MsgUpdate -> Game.Config -> Game.Config
updateConfig update config =
    case update of
        UpdateRows rows ->
            { config | rows = Utils.toInt rows }

        UpdateColumns columns ->
            { config | columns = Utils.toInt columns }

        UpdateMines mines ->
            { config | mines = Utils.toInt mines }

updateButton : MsgButton -> Game.Model -> Game.Model
updateButton buttons game =
    case buttons of
        OK ->
            { game | dialogOpen = False }
        Cancel ->
            { game | dialogOpen = False }