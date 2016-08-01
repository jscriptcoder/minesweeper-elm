module Menu exposing (..)

import Html exposing (ul, li, text)
import Html.Attributes exposing (class)



-- VIEW

view model =
    ul [ class "menu" ]
    [ li [ class "menu-new" ] [ text "New" ]
    , li [ class "menu-divider" ] []
    , li [ class "game-level menu-beginner checked" ] [ text "Beginner" ]
    , li [ class "game-level menu-intermediate" ] [ text "Intermediate" ]
    , li [ class "game-level menu-expert" ] [ text "Expert" ]
    , li [ class "game-level menu-custom" ] [ text "Custom…" ]
    , li [ class "menu-divider" ] []
    , li [ class "checked" ] [ text "Marks (?)" ]
    ]