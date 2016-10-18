module Components.Header
    exposing
        ( Msg(..)
        , Face(..)
        , Model
        , model
        , view
        , update
        , subscriptions
        )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events
    exposing
        ( onMouseDown
        , onMouseUp
        , onMouseLeave
        , onClick
        )
import String exposing (padLeft, slice)
import Time exposing (Time, every, second)
import Components.Global as Global


-- MESSAGES


type Msg
    = FaceDown
    | FaceUp
    | FaceLeave
    | Tick Time
    | ResetGame


type Face
    = Smile
    | Pressed
    | Surprised
    | Sad



-- MODEL


type alias Model =
    { flags : Int
    , face : Face
    , timer : Int
    }


model : Model
model =
    { flags = 0
    , face = Smile
    , timer = 0
    }



-- VIEW


view : Model -> Global.Model -> Html Msg
view model global =
    div [ class "header-wrapper" ]
        [ div [ class "header-container" ]
            [ div [ class "header" ]
                [ viewMineCount model global
                , viewFace model.face
                , viewTimer model.timer
                ]
            ]
        ]


viewMineCount : Model -> Global.Model -> Html Msg
viewMineCount model global =
    let
        ( hundres, tens, ones ) =
            getDigits <| global.mines - model.flags
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
        ]
        []


viewTimer : Int -> Html Msg
viewTimer timer =
    let
        ( hundres, tens, ones ) =
            getDigits timer
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

        Tick _ ->
            { model | timer = model.timer + 1 }

        ResetGame ->
            { model | timer = 0 }



-- SUBSCRIPTIONS


subscriptions : Model -> Global.Model -> Sub Msg
subscriptions model global =
    if Global.isStarted global.state then
        every second Tick
    else
        Sub.none



-- Helpers


getDigits : Int -> ( String, String, String )
getDigits num =
    let
        digits =
            num
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
        Smile ->
            "smile"

        Pressed ->
            "pressed"

        Surprised ->
            "surprised"

        Sad ->
            "sad"
