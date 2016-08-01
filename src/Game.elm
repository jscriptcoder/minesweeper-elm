module Game exposing (Model, model, view)

import Html exposing (div)
import Html.Attributes exposing (class)
import Custom
import Board



-- MESSAGES

type Msg
    = CustomMsg Custom.Msg
    | BoardMsg Board.Msg



-- MODEL

type alias Model =
    { mines : Int
    , rows : Int
    , columns : Int
    , customOpen : Bool
    , board : Board.Model
    }

model : Model
model = 
    { mines = 10
    , rows = 9
    , columns = 9
    , customOpen = False
    , board = Board.model
    }


-- VIEW

view : Model -> Html Msg
view model =
    div [ class "game-container" ]
        [ Custom.view model
        , Board.view model
        ]