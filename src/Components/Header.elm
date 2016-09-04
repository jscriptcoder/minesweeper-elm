module Components.Header exposing
    ( Msg(..), Face(..)
    , Model, model
    , view
    , update
    )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events exposing
    ( onMouseDown
    , onMouseUp
    , onMouseLeave
    , onClick
    )
import String exposing (padLeft, slice)

import Components.Config as Config



-- MESSAGES


type Msg
    = FaceDown
    | FaceUp
    | FaceLeave
    | ResetGame

type Face
    = Smile
    | Pressed
    | Surprised
    | Sad


-- MODEL


type alias Model =
    { timer : Int
    , face : Face
    }

model : Model
model =
    { timer = 0
    , face = Smile
    }



-- VIEW


view : Model -> Config.Model -> Html Msg
view model config = 
    div [ class "header-wrapper" ]
        [ div [ class "header-container" ]
            [ div [ class "header" ]
                [ viewMineCount model config
                , viewFace model.face
                , viewTimer model.timer
                ]
            ]
        ]

viewMineCount : Model -> Config.Model -> Html Msg
viewMineCount model config =
    let
        (hundres, tens, ones) = getDigits config.mines
    in
        div [ class "mine-count numbers" ]
            [ div [ class <| "digit hundres t" ++ hundres ] []
            , div [ class <| "digit tens t" ++ tens ] []
            , div [ class <| "digit ones t" ++ ones ] []
            ]

viewFace : Face -> Html Msg
viewFace face =
    div
        [ class <| "reset-button face-" ++ (typeFace face)
        , onMouseDown FaceDown
        , onMouseUp FaceUp
        , onMouseLeave FaceLeave
        , onClick ResetGame
        ] []

viewTimer : Int -> Html Msg
viewTimer timer =
    let
        (hundres, tens, ones) = getDigits timer
    in
        div [ class "timer numbers" ]
            [ div [ class <| "digit hundres t" ++ hundres ] []
            , div [ class <| "digit tens t" ++ tens ] []
            , div [ class <| "digit ones t" ++ ones ] []
            ]



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        FaceDown ->
            { model | face = Pressed }

        FaceUp ->
            { model | face = Smile }

        FaceLeave ->
            if model.face == Pressed then
                update FaceUp model
            else
                model

        ResetGame ->
            { model | timer = 0 }



-- Helpers


getDigits : Int -> (String, String, String)
getDigits num =
    let
        digits = num
                    |> toString
                    |> padLeft 3 '0'
    in
        ( slice 0 1 digits
        , slice 1 2 digits
        , slice 2 3 digits
        )

typeFace : Face -> String
typeFace face =
    case face of
        Smile -> "smile"
        Pressed -> "pressed"
        Surprised -> "surprised"
        Sad -> "sad"