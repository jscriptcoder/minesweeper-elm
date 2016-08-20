module Components.Menu exposing
    ( Msg, OutMsg(..)
    , Model, model
    , view, update
    , toggleOpen
    )

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)



-- MESSAGES

type Msg
    = NewGame
    | BeginnerLevel
    | IntermediateLevel
    | ExpertLevel
    | CustomLevel
    | CheckMarks

type OutMsg = OpenCustomDialog



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
    , li [ class "game-level menu-beginner checked", onClick BeginnerLevel ] [ text "Beginner" ]
    , li [ class "game-level menu-intermediate", onClick IntermediateLevel ] [ text "Intermediate" ]
    , li [ class "game-level menu-expert", onClick ExpertLevel ] [ text "Expert" ]
    , li [ class "game-level menu-custom", onClick CustomLevel ] [ text "Custom..." ]
    , li [ class "menu-divider" ] []
    , li [ class "menu-marks checked", onClick CheckMarks ] [ text "Marks (?)" ]
    ]



-- UPDATE

update : Msg -> Model -> (Model, Maybe OutMsg)
update msg model =
    case msg of
        NewGame ->
            (model, Nothing)

        BeginnerLevel ->
            (model, Nothing)

        IntermediateLevel ->
            (model, Nothing)

        ExpertLevel ->
            (model, Nothing)

        CustomLevel ->
            (model, Just OpenCustomDialog)

        CheckMarks ->
            (model, Nothing)



-- Helpers

toggleOpen : Model -> Model
toggleOpen model =
    { model | open = not model.open }