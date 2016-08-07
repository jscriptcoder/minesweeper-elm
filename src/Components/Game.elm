module Game exposing (Config, Model, config, model, view)

import Html exposing (div)
import Html.Attributes exposing (class)
import Dialog
import Board



-- MESSAGES

type Msg
    = DialogMsg Dialog.Msg
    | BoardMsg Board.Msg



-- MODEL

type alias Config =
    { mines : Int
    , rows : Int
    , columns : Int
    , level : Int
    , marks : Bool
    }

config : Config
config =
    { mines = 10
    , rows = 9
    , columns = 9
    , level = 1
    , marks = True
    }


type alias Model =
    { dialogOpen : Bool
    , config : Config
    , board : Board.Model
    }

model : Model
model = 
    { dialogOpen = False
    , config = config
    , board = Board.model
    }



-- VIEW

view : Model -> Html Msg
view model =
    div [ class "game-container" ]
        [ Dialog.view config model
        , Board.view model
        ]



-- UPDATE

update : Msg -> Model -> Model
update msg model =
    case msg of
