module Custom exposing (Msg, view)

import Html exposing (div, p, label, input, text)
import Html.Attributes exposing (class, classList, type', value)
import Html.Events exposing (onInput, onClick)
import Game



-- MESSAGES

type Msg
    = UpdateRows String
    | UpdateColumns String
    | UpdateMines String
    | OK
    | Cancel



-- VIEW

view : Game.Model -> Html Msg
view model =
    div [ classList
            [ ("custom-level-dialog", True)
            , ("window-wrapper-outer", True)
            , ("open", model.customOpen)
            ]
        ] 
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar"] []
                , div [ class "content" ]
                    [ viewFields model.rows model.columns model.mines
                    , viewButtons
                    ]
                ]
            ]
        ]

viewFields : Int -> Int -> Int -> Html Msg
viewFields rows columns mines =
    div [ class "fields" ]
        [ p []
            [ label [] [ text "Height:"]
            , input [ class "form-textbox custom-height"
                    , type' "text"
                    , value <| toString rows
                    , onInput UpdateRows
                    ] []
            ]
        , p []
            [ label [] [ text "Width:"]
            , input [ class "form-textbox custom-width"
                    , type' "text"
                    , value <| toString columns
                    , onInput UpdateColumns
                    ] []
            ]
        , p []
            [ label [] [ text "Mines:"]
            , input [ class "form-textbox custom-mines"
                    , type' "text"
                    , value <| toString mines
                    , onInput UpdateMines
                    ] []
            ]
        ]

viewButtons : Html Msg
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