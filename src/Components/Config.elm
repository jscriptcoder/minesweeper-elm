module Components.Config
    exposing
        ( Model
        , model
        , beginnerLevel
        , intermediateLevel
        , expertLevel
        , customLevel
        , isBeginnerLevel
        , isIntermediateLevel
        , isExpertLevel
        , isCustomLevel
        , toggleMarks
        )

-- MODEL


type Level
    = Beginner
    | Intermediate
    | Expert
    | Custom


type alias Model =
    { mines : Int
    , rows : Int
    , columns : Int
    , level : Level
    , marks : Bool
    }


model : Model
model =
    { mines = 10
    , rows = 9
    , columns = 9
    , level = Beginner
    , marks = True
    }



-- Helpers


beginnerLevel : Model -> Model
beginnerLevel model =
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
    { model
        | mines = mines
        , rows = rows
        , columns = columns
        , level = Custom
    }


isCustomLevel : Level -> Bool
isCustomLevel level =
    level == Custom


toggleMarks : Model -> Model
toggleMarks model =
    { model | marks = not model.marks }
