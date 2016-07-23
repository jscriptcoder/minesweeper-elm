module Tile exposing (Model, update, view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Utils exposing (onRightClick)


-- MODEL

type alias Model = 
    { isMine : Bool
    , isOpened : Bool
    , isMarked : Bool
    }

init: (Model, Cmd Action)
init = ({ isMine = False
        , isOpened = False
        , isMarked = False
        }, Cmd.none )


-- UPDATE

type Action = Open | Mark

update: Action -> Model -> (Model, Cmd Action)
update action model =
    case action of
        Open -> ({ model | isOpened = True }, Cmd.none)
        Mark -> ({ model | isMarked = True }, Cmd.none)



-- VIEW

view: Model -> Html Action
view tile =
    div [ class "tile"
        , onClick Open
        , onRichtClick Mark
        ] []