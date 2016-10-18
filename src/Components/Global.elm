module Components.Global
    exposing
        ( Model
        , model
        , init
        , beginnerLevel
        , intermediateLevel
        , expertLevel
        , customLevel
        , isBeginnerLevel
        , isIntermediateLevel
        , isExpertLevel
        , isCustomLevel
        , isReady
        , setReady
        , isStarted
        , setStarted
        , isOver
        , setOver
        , toggleMarks
        )

import Random
    exposing
        ( Seed
        , Generator
        , initialSeed
        , list
        , int
        , step
        )
import List
    exposing
        ( head
        , tail
        , member
        , append
        )


-- MODEL


type Level
    = Beginner
    | Intermediate
    | Expert
    | Custom


type State
    = Ready
    | Started
    | Over


type alias Model =
    { state : State
    , seed : Seed
    , randomMines : List Int
    , mines : Int
    , rows : Int
    , columns : Int
    , level : Level
    , marks : Bool
    }


model : Model
model =
    { state = Ready
    , seed = initialSeed 0
    , randomMines = []
    , mines = 10
    , rows = 9
    , columns = 9
    , level = Beginner
    , marks = True
    }



-- Helpers


generateRandomMines : Model -> Model
generateRandomMines model =
    let
        size =
            model.mines

        min =
            1

        max =
            (model.rows * model.columns)

        generatorList =
            createGenerator size min max

        ( randomMines, nextSeed ) =
            step generatorList model.seed
    in
        { model
            | seed = nextSeed
            , randomMines = sanitizeList randomMines min max
        }


createGenerator : Int -> Int -> Int -> Generator (List Int)
createGenerator size min max =
    list size <| int min max


sanitizeList : List Int -> Int -> Int -> List Int
sanitizeList list min max =
    sanitizeListHelper list min max []


sanitizeListHelper : List Int -> Int -> Int -> List Int -> List Int
sanitizeListHelper list min max result =
    let
        maybeHead =
            head list

        maybeTail =
            tail list
    in
        case maybeHead of
            Just head ->
                case maybeTail of
                    Just tail ->
                        if (member head tail) || (member head result) then
                            if (head + 1) <= max then
                                sanitizeListHelper ((head + 1) :: tail) min max result
                            else
                                sanitizeListHelper (min :: tail) min max result
                        else
                            sanitizeListHelper tail min max (append result [ head ])

                    Nothing ->
                        result

            Nothing ->
                result


init : Model -> Model
init model =
    generateRandomMines
        { model | state = Ready }


beginnerLevel : Model -> Model
beginnerLevel model =
    init
        { model
            | mines = 10
            , rows = 9
            , columns = 9
            , level = Beginner
        }


isBeginnerLevel : Level -> Bool
isBeginnerLevel level =
    level == Beginner


intermediateLevel : Model -> Model
intermediateLevel model =
    init
        { model
            | mines = 40
            , rows = 16
            , columns = 16
            , level = Intermediate
        }


isIntermediateLevel : Level -> Bool
isIntermediateLevel level =
    level == Intermediate


expertLevel : Model -> Model
expertLevel model =
    init
        { model
            | mines = 99
            , rows = 16
            , columns = 30
            , level = Expert
        }


isExpertLevel : Level -> Bool
isExpertLevel level =
    level == Expert


customLevel : Model -> Int -> Int -> Int -> Model
customLevel model mines rows columns =
    init
        { model
            | mines = mines
            , rows = rows
            , columns = columns
            , level = Custom
        }


isCustomLevel : Level -> Bool
isCustomLevel level =
    level == Custom


isReady : State -> Bool
isReady state =
    state == Ready


setReady : Model -> Model
setReady model =
    { model | state = Ready }


isStarted : State -> Bool
isStarted state =
    state == Started


setStarted : Model -> Model
setStarted model =
    { model | state = Started }


isOver : State -> Bool
isOver state =
    state == Over


setOver : Model -> Model
setOver model =
    { model | state = Over }


toggleMarks : Model -> Model
toggleMarks model =
    { model | marks = not model.marks }
