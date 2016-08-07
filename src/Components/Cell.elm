module Cell exposing (Model, model, view)

import Html exposing (div)
import Html.Attributes exposing (class)
import Html.Events exposing (onMouseDown, onMouseUp)



-- MESSAGES

type Msg
    = MouseDown
    | MouseUp



-- MODEL

type alias Model =
    { open : Bool
    , marked : Bool
    , bomb : Bool
    , value : Int
    } 

model : Model
model = 
    { open = False
    , marked = False
    , bomb = False
    , value = 0
    }



-- VIEW

view : Model -> Html Msg
view model =
    div [ class "cell covered"
        , onMouseDown MouseDown
        , onMouseUp MouseUp
        ] []



-- UPDATE
update msg model =
    case msg of