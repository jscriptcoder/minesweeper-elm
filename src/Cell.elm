module Cell exposing (model, view)

import Html exposing (div)
import Html.Attributes exposing (class)



-- MODEL

model = 
    { open = False
    , marked = False
    , bomb = False
    , value = 0
    }



-- VIEW

view model =
    div [ class "cell covered" ] []