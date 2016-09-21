module Components.Cell
    exposing
        ( Msg(..)
        , State(..)
        , Model
        , model
        , view
        , update
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
import Components.Utils exposing (onRightClick)


-- MESSAGES


type Msg
    = MouseDown Model
    | MouseUp Model
    | MouseLeave Model
    | RightClick Model


type State
    = Opened
    | Closed
    | Pressed
    | Flag
    | Question
    | Mine
    | MineHit



-- MODEL


type alias Model =
    { id : Int
    , state : State
    , prevState : State
    , mine : Bool
    , value : Int
    }


model : Model
model =
    { id = 0
    , state = Closed
    , prevState = Closed
    , mine = False
    , value = 0
    }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class <| "cell " ++ (typeCell model)
        , onMouseDown (MouseDown model)
        , onMouseUp (MouseUp model)
        , onMouseLeave (MouseLeave model)
        , onRightClick (RightClick model)
        ]
        []



-- UPDATE


update : Msg -> Model
update msg =
    case msg of
        MouseDown model ->
            if isReadyToOpen model then
                { model | state = Pressed, prevState = model.state }
            else
                model

        MouseUp model ->
            if model.state == Pressed then
                if model.mine == True then
                    { model | state = MineHit }
                else
                    { model | state = Opened }
            else
                model

        MouseLeave model ->
            if model.state == Pressed then
                { model | state = model.prevState }
            else
                model

        RightClick model ->
            case model.state of
                Closed ->
                    { model | state = Flag, prevState = model.state }

                Flag ->
                    { model | state = Question, prevState = model.state }

                Question ->
                    { model | state = Closed, prevState = model.state }

                _ ->
                    model



-- Helpers


typeCell : Model -> String
typeCell model =
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
            "mine"

        MineHit ->
            "mine-hit"


isReadyToOpen : Model -> Bool
isReadyToOpen model =
    if
        model.state
            == Closed
            || model.state
            == Flag
            || model.state
            == Question
    then
        True
    else
        False
