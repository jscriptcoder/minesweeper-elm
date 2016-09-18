module Components.Menu
    exposing
        ( Msg(..)
        , Model
        , model
        , view
        , update
        , toggleOpen
        )

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Components.Config as Config


-- MESSAGES


type Msg
    = NewGame
    | BeginnerLevel
    | IntermediateLevel
    | ExpertLevel
    | CustomLevel
    | CheckMarks



-- MODEL


type alias Model =
    { open : Bool }


model : Model
model =
    { open = False
    }



-- VIEW


view : Model -> Config.Model -> Html Msg
view model config =
    ul [ classList [ ( "menu", True ), ( "open", model.open ) ] ]
        [ li [ class "menu-new", onClick NewGame ] [ text "New" ]
        , li [ class "menu-divider" ] []
        , li
            [ classList
                [ ( "game-level menu-beginner", True )
                , ( "checked", Config.isBeginnerLevel config.level )
                ]
            , onClick BeginnerLevel
            ]
            [ text "Beginner" ]
        , li
            [ classList
                [ ( "game-level menu-intermediate", True )
                , ( "checked", Config.isIntermediateLevel config.level )
                ]
            , onClick IntermediateLevel
            ]
            [ text "Intermediate" ]
        , li
            [ classList
                [ ( "game-level menu-expert", True )
                , ( "checked", Config.isExpertLevel config.level )
                ]
            , onClick ExpertLevel
            ]
            [ text "Expert" ]
        , li
            [ classList
                [ ( "game-level menu-custom", True )
                , ( "checked", Config.isCustomLevel config.level )
                ]
            , onClick CustomLevel
            ]
            [ text "Custom..." ]
        , li [ class "menu-divider" ] []
        , li
            [ classList
                [ ( "menu-marks", True )
                , ( "checked", config.marks )
                ]
            , onClick CheckMarks
            ]
            [ text "Marks (?)" ]
        ]



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    toggleOpen model



-- Helpers


toggleOpen : Model -> Model
toggleOpen model =
    { model | open = not model.open }
