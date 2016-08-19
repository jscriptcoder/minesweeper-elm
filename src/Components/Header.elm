module Components.Header exposing (Msg, Model, model, view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)



-- MESSAGES

type Msg
    = NoOp



-- MODEL

type alias Model =
    {}

model : Model
model = 
    {}



-- VIEW

view model = 
    div [ class "header-wrapper" ]
        [ div [ class "header-container" ]
            [ div [ class "header" ]
                [ viewMineCount model
                , div [ class "reset-button face-smile" ] []
                , viewTimer model
                ]
            ]
        ]

viewMineCount model =
    div [ class "mine-count numbers" ]
        [ div [ class "digit hundres t0" ] []
        , div [ class "digit tens t0" ] []
        , div [ class "digit ones t0" ] []
        ]

viewTimer model =
    div [ class "timer numbers" ]
        [ div [ class "digit hundres t0" ] []
        , div [ class "digit tens t0" ] []
        , div [ class "digit ones t0" ] []
        ]