module Components.Config exposing
    ( Model, model
    , beginnerLevel
    , intermediateLevel
    , expertLevel
    , customLevel
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

beginnerLevel : Model -> Model
beginnerLevel model =
    { model | 
        mines = 10, 
        rows = 9, 
        columns = 9, 
        level = Beginner
    }

intermediateLevel : Model -> Model
intermediateLevel model =
    { model | 
        mines = 40, 
        rows = 16, 
        columns = 16, 
        level = Intermediate
    }

expertLevel : Model -> Model
expertLevel model =
    { model | 
        mines = 99, 
        rows = 16, 
        columns = 30, 
        level = Intermediate
    }

customLevel : Model -> Int -> Int -> Int -> Model
customLevel model mines rows columns =
    { model | 
        mines = mines, 
        rows = rows, 
        columns = columns, 
        level = Custom
    }