module Components.Header exposing (Msg, Model, model, view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)

import Components.Config as Config



-- MESSAGES

type Msg
    = NoOp



-- MODEL

type alias Model = { timer : Int }

model : Model
model = { timer = 0 }



-- VIEW

view : Model -> Config.Model -> Html Msg
view model config = 
    div [ class "header-wrapper" ]
        [ div [ class "header-container" ]
            [ div [ class "header" ]
                [ viewMineCount model config
                , div [ class "reset-button face-smile" ] []
                , viewTimer model
                ]
            ]
        ]

viewMineCount : Model -> Config.Model -> Html Msg
viewMineCount model config =
    div [ class "mine-count numbers" ]
        [ div [ class "digit hundres t0" ] []
        , div [ class "digit tens t0" ] []
        , div [ class "digit ones t0" ] []
        ]

viewTimer : Model -> Html Msg
viewTimer model =
    div [ class "timer numbers" ]
        [ div [ class "digit hundres t0" ] []
        , div [ class "digit tens t0" ] []
        , div [ class "digit ones t0" ] []
        ]