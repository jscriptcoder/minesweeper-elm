module Game exposing (Level, Config, Model, config, model, view)

import Html exposing (div)
import Html.Attributes exposing (class)
import Html.App as App
import Dialog
import Board



-- MESSAGES

type Msg
    = DialogMsg Dialog.Msg
    | BoardMsg Board.Msg



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
    , dialog : Dialog.Model
    , board : Board.Model
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
    , dialog = Dialog.model
    , board = Board.model
    }



-- VIEW

view : Model -> Html Msg
view model =
    div [ class "game-container" ]
        [ App.map DialogMsg (Dialog.view config model)
        , App.map BoardMsg (Board.view model)
        ]



-- UPDATE

update : Msg -> Model -> Model
update msg model =
    case msg of
        DialogMsg dialogMsg ->
            (Dialog.update dialogMsg model, Cmd.none)

        BoardMsg boardMsg ->
            (Board.update boardMsg model, Cmd.none)