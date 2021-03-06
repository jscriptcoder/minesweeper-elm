module Components.Cell
    exposing
        ( Msg(..)
        , State(..)
        , Model
        , model
        , view
        , update
        , isReadyToOpen
        , makeCell
        , isEmpty
        , canOpen
        , isCoveredMine
        )

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events
    exposing
        ( onMouseDown
        , onMouseLeave
        , onClick
        )
import List exposing (member)
import Matrix exposing (Location)
import Components.Global as Global
import Components.Utils exposing (onRightClick)


-- MESSAGES


type Msg
    = MouseDown Model
    | MouseLeave Model
    | MouseClick Model
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
    , loc : Location
    }


model : Model
model =
    { id = 0
    , state = Closed
    , prevState = Closed
    , mine = False
    , value = 0
    , loc = ( -1, -1 )
    }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class <| "cell " ++ (typeCell model)
        , onMouseDown (MouseDown model)
        , onMouseLeave (MouseLeave model)
        , onClick (MouseClick model)
        , onRightClick (RightClick model)
        ]
        []



-- UPDATE


update : Msg -> Global.Model -> Maybe Model
update msg global =
    case msg of
        MouseDown model ->
            if isReadyToOpen model then
                Just { model | state = Pressed, prevState = model.state }
            else
                Nothing

        MouseLeave model ->
            if model.state == Pressed then
                Just { model | state = model.prevState }
            else
                Nothing

        MouseClick model ->
            if model.state == Pressed then
                if model.mine then
                    Just { model | state = MineHit }
                else
                    Just { model | state = Opened }
            else
                Nothing

        RightClick model ->
            case model.state of
                Closed ->
                    Just { model | state = Flag, prevState = model.state }

                Flag ->
                    if global.marks then
                        Just { model | state = Question, prevState = model.state }
                    else
                        Just { model | state = Closed, prevState = model.state }

                Question ->
                    Just { model | state = Closed, prevState = model.state }

                _ ->
                    Nothing



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
    model.state
        == Closed
        || model.state
        == Question


makeCell : Int -> Location -> List Int -> Model
makeCell width location randomMines =
    let
        row =
            1 + Matrix.row location

        col =
            1 + Matrix.col location

        id =
            col + (width * (row - 1))

        cell =
            { model
                | id = col + (width * (row - 1))
                , loc = location
            }
    in
        if member id randomMines then
            { cell | mine = True }
        else
            cell


isEmpty : Model -> Bool
isEmpty model =
    let
        isNotMine =
            not model.mine

        isNotFlag =
            model.state /= Flag

        hasNoValue =
            model.value == 0
    in
        isNotMine
            && isNotFlag
            && hasNoValue


canOpen : Model -> Bool
canOpen model =
    let
        isNotMine =
            not model.mine

        isNotFlag =
            model.state /= Flag

        isClosed =
            model.state == Closed
    in
        isNotMine
            && isNotFlag
            && isClosed


isCoveredMine : Model -> Bool
isCoveredMine model =
    model.mine && model.state == Closed
