module Dialog exposing (Msg, view)

import Html exposing (Html, div, p, label, input, text)
import Html.Attributes exposing (class, classList, type', value)
import Html.Events exposing (onInput, onClick)
import Html.App as App
import Utils
import Game



-- MESSAGES

type UpdateInput
    = UpdateRows String
    | UpdateColumns String
    | UpdateMines String

type Button
    = OK
    | Cancel

type Msg
    = UpdateMsg UpdateInput
    | ButtonMsg Button



-- MODEL

type alias Model =
    { open : Bool
    , rows : Int
    , columns : Int
    , mines : Int
    }

-- VIEW

view : Model -> Html Msg
view model =
    div [ classList
            [ ("custom-level-dialog", True)
            , ("window-wrapper-outer", True)
            , ("open", model.open)
            ]
        ] 
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar"] []
                , div [ class "content" ]
                    [ App.map UpdateMsg (viewFields model)
                    , App.map ButtonMsg viewButtons
                    ]
                ]
            ]
        ]

viewFields : Model -> Html UpdateMsg
viewFields model =
    div [ class "fields" ]
        [ p []
            [ label [] [ text "Height:"]
            , input [ class "form-textbox custom-height"
                    , type' "text"
                    , value (toString model.rows)
                    , onInput UpdateRows
                    ] []
            ]
        , p []
            [ label [] [ text "Width:"]
            , input [ class "form-textbox custom-width"
                    , type' "text"
                    , value (toString model.columns)
                    , onInput UpdateColumns
                    ] []
            ]
        , p []
            [ label [] [ text "Mines:"]
            , input [ class "form-textbox custom-mines"
                    , type' "text"
                    , value (toString model.mines)
                    , onInput UpdateMines
                    ] []
            ]
        ]

viewButtons : Html ButtonMsg
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

update : Msg -> Game.Model -> Game.Model
update msg gameModel =
    case msg of
        MsgUpdate updateInputMsg ->
            { gameModel | dialog = updateFields updateInputMsg gameModel.dialog }

        MsgButton buttons ->
            updateButton buttons gameModel

updateFields : UpdateMsg -> Model -> Model
updateFields updateMsg model =
    case updateMsg of
        UpdateRows rows ->
            { model | rows = Utils.toInt rows }

        UpdateColumns columns ->
            { model | columns = Utils.toInt columns }

        UpdateMines mines ->
            { model | mines = Utils.toInt mines }

updateButton : ButtonMsg -> Game.Model -> Game.Model
updateButton buttonMsg gameModel =
    case buttonMsg of
        OK ->
            { gameModel | 
                config = updateConfig gameModel.config gameModel.dialog, 
                dialog = closeDialog gameModel.dialog }

        Cancel ->
            { gameModel | dialog = closeDialog gameModel.dialog }

updateConfig : Game.Config -> Model -> Game.Model
updateConfig gameConfig model =
    { gameConfig | 
        mines = model.mines, 
        rows = model.rows, 
        columns = model.columns, 
        level = Custom }

closeDialog : Model -> Model
closeDialog model =
    { model | open = False }