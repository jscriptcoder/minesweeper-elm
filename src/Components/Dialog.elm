module Components.Dialog exposing
    ( Msg, OutMsg(..)
    , Model, model 
    , view, update
    , toggleOpen
    )

import Html exposing (Html, div, p, label, input, text)
import Html.Attributes exposing (class, classList, type', value)
import Html.Events exposing (onInput, onClick)
import Html.App as App

import Components.Config as Config
import Components.Utils as Utils



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

-- for communication child -> parent
type OutMsg = SaveCustomLevel



-- MODEL

type alias Model =
    { open : Bool
    , rows : Int
    , columns : Int
    , mines : Int
    }

model : Model
model = 
    { open = False
    , rows = .rows Config.model
    , columns = .columns Config.model
    , mines = .mines Config.model
    }

-- VIEW

view : Model -> Html Msg
view model =
    div [ classList
            [ ("custom-level-dialog window-wrapper-outer", True)
            , ("open", model.open)
            ]
        ] 
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar"] []
                , div [ class "content" ]
                    [ App.map UpdateMsg <| viewFields model
                    , App.map ButtonMsg viewButtons
                    ]
                ]
            ]
        ]

viewFields : Model -> Html UpdateInput
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

viewButtons : Html Button
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

update : Msg -> Model -> (Model, Maybe OutMsg)
update msg model =
    case msg of
        UpdateMsg updateInput ->
            (updateFields updateInput model, Nothing)

        ButtonMsg button ->
            let newModel = toggleOpen model
            in updateButton button newModel

updateFields : UpdateInput -> Model -> Model
updateFields updateInput model =
    case updateInput of
        UpdateRows rows ->
            { model | rows = Utils.toInt rows }

        UpdateColumns columns ->
            { model | columns = Utils.toInt columns }

        UpdateMines mines ->
            { model | mines = Utils.toInt mines }

updateButton : Button -> Model -> (Model, Maybe OutMsg)
updateButton buttonMsg model =
        case buttonMsg of
            OK ->
                (model, Just SaveCustomLevel)

            Cancel ->
                (model, Nothing)



-- Helpers

toggleOpen : Model -> Model
toggleOpen model =
    { model | open = not model.open }
