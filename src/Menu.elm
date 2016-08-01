module Menu exposing (Msg, view)

import Html exposing (ul, li, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Board



-- MESSAGES

type Msg
    = NewGame
    | LevelBeginner
    | LevelIntermediate
    | LevelExpert
    | OpenCustomDialog
    | CheckMarks



-- VIEW

view : Board.Model -> Html Msg
view model =
    ul [ classList [ ("menu", True), ("open", model.menuOpen) ] ]
    [ li [ class "menu-new", onClick NewGame ] [ text "New" ]
    , li [ class "menu-divider" ] []
    , li [ class "game-level menu-beginner checked", onClick LevelBeginner ] [ text "Beginner" ]
    , li [ class "game-level menu-intermediate", onClick LevelIntermediate ] [ text "Intermediate" ]
    , li [ class "game-level menu-expert" onClick LevelExpert ] [ text "Expert" ]
    , li [ class "game-level menu-custom" onClick OpenCustomDialog ] [ text "Custom..." ]
    , li [ class "menu-divider" ] []
    , li [ class "menu-marks checked" onClick CheckMarks ] [ text "Marks (?)" ]
    ]



-- UPDATE