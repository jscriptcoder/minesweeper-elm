module Components.Game exposing (Level, Config, Model, config, model, view, update)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)



-- MESSAGES

type Msg = Something



-- MODEL

type Level
    = Beginner
    | Intermediate
    | Expert
    | Custom

type alias Config =
    { mines : Int
    , rows : Int
    , columns : Int
    , level : Level
    , marks : Bool
    }

type alias Model =
    { config : Config
    }

config : Config
config =
    { mines = 10
    , rows = 9
    , columns = 9
    , level = Beginner
    , marks = True
    }

model : Model
model = 
    { config = config
    }



-- VIEW

view : Model -> Html Msg
view model =
    div [ class "game-container" ]
        [ text "Minesweeper!!" ]



-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Something -> (model, Cmd.none)