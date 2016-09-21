module Components.Cell
    exposing
        ( Msg(..)
        , State(..)
        , Model
        , model
        , view
        )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events
    exposing
        ( onMouseDown
        , onMouseUp
        , onMouseLeave
        )


-- MESSAGES


type Msg
    = MouseDown
    | MouseUp
    | MouseLeave


type State
    = Opened
    | Closed
    | Pressed
    | Flag
    | Question
    | Mine



-- MODEL


type alias Model =
    { id : Int
    , state : State
    , mine : Bool
    , value : Int
    }


model : Model
model =
    { id = 0
    , state = Closed
    , mine = False
    , value = 0
    }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class <| "cell " ++ (typeCell model)
        , onMouseDown MouseDown
        , onMouseUp MouseUp
        , onMouseLeave MouseLeave
        ]
        []



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        MouseDown ->
            if model.state == Closed then
                { model | state = Pressed }
            else
                model

        MouseUp ->
            if model.state == Pressed then
                -- todo: calculate value
                { model
                    | value = 0
                    , state = Opened
                }
            else
                model

        MouseLeave ->
            if model.state == Pressed then
                { model | state = Closed }
            else
                model



-- Helpers


typeCell : Model -> String
typeCell model =
    if model.mine == True then
        "mine"
    else
        case model.state of
            Pressed ->
                "mines0"

            Opened ->
                "mines" ++ (toString model.value)

            Closed ->
                "covered"

            Flag ->
                "flag"

            Question ->
                "question"

            Mine ->
                "Mine"
