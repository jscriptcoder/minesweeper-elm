module Game exposing (model, view)

import Html exposing (div)
import Html.Attributes exposing (class)
import Dialog
import Board



-- MODEL

model = 
    { mines = 10
    , rows = 9
    , columns = 9
    }


-- VIEW

view model =
    div [ class "game-container" ]
        [ Dialog.view model
        , Board.view model
        ]