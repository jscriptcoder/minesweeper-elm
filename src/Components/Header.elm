module Components.Header exposing (Msg, Model, model, view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import String exposing (padLeft, slice)

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
    let
        (hundres, tens, ones) = getMinesDigits config.mines
    in
        div [ class "mine-count numbers" ]
            [ div [ class ("digit hundres t" ++ hundres) ] []
            , div [ class ("digit tens t" ++ tens) ] []
            , div [ class ("digit ones t" ++ ones) ] []
            ]

viewTimer : Model -> Html Msg
viewTimer model =
    div [ class "timer numbers" ]
        [ div [ class "digit hundres t0" ] []
        , div [ class "digit tens t0" ] []
        , div [ class "digit ones t0" ] []
        ]



-- Helpers

getMinesDigits : Int -> (String, String, String)
getMinesDigits mines =
    let
        minesDigits = mines
                            |> toString
                            |> padLeft 3 '0'
    in
        ( slice 0 1 minesDigits
        , slice 1 2 minesDigits
        , slice 2 3 minesDigits
        )