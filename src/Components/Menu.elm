module Components.Menu exposing
    ( Msg
    , Model, model
    , view, update
    , toggleOpen
    )

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)



-- MESSAGES

type Msg
    = ToggleOpen
    | NewGame
    | LevelBeginner
    | LevelIntermediate
    | LevelExpert
    | OpenCustomDialog
    | CheckMarks



-- MODEL

type alias Model =
    { open : Bool }

model : Model
model = 
    { open = False
    }


-- VIEW

view : Model -> Html Msg
view model =
    ul [ classList [ ("menu", True), ("open", model.open) ] ]
    [ li [ class "menu-new", onClick NewGame ] [ text "New" ]
    , li [ class "menu-divider" ] []
    , li [ class "game-level menu-beginner checked", onClick LevelBeginner ] [ text "Beginner" ]
    , li [ class "game-level menu-intermediate", onClick LevelIntermediate ] [ text "Intermediate" ]
    , li [ class "game-level menu-expert", onClick LevelExpert ] [ text "Expert" ]
    , li [ class "game-level menu-custom", onClick OpenCustomDialog ] [ text "Custom..." ]
    , li [ class "menu-divider" ] []
    , li [ class "menu-marks checked", onClick CheckMarks ] [ text "Marks (?)" ]
    ]



-- UPDATE

update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleOpen ->
            toggleOpen model

        NewGame ->
            model

        LevelBeginner ->
            model

        LevelIntermediate ->
            model

        LevelExpert ->
            model

        OpenCustomDialog ->
            model

        CheckMarks ->
            model



-- Helpers

toggleOpen : Model -> Model
toggleOpen model =
    { model | open = not model.open }