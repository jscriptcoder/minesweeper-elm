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
import Components.Global as Global


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


view : Model -> Global.Model -> Html Msg
view model global =
    ul [ classList [ ( "menu", True ), ( "open", model.open ) ] ]
        [ li [ class "menu-new", onClick NewGame ] [ text "New" ]
        , li [ class "menu-divider" ] []
        , li
            [ classList
                [ ( "game-level menu-beginner", True )
                , ( "checked", Global.isBeginnerLevel global.level )
                ]
            , onClick BeginnerLevel
            ]
            [ text "Beginner" ]
        , li
            [ classList
                [ ( "game-level menu-intermediate", True )
                , ( "checked", Global.isIntermediateLevel global.level )
                ]
            , onClick IntermediateLevel
            ]
            [ text "Intermediate" ]
        , li
            [ classList
                [ ( "game-level menu-expert", True )
                , ( "checked", Global.isExpertLevel global.level )
                ]
            , onClick ExpertLevel
            ]
            [ text "Expert" ]
        , li
            [ classList
                [ ( "game-level menu-custom", True )
                , ( "checked", Global.isCustomLevel global.level )
                ]
            , onClick CustomLevel
            ]
            [ text "Custom..." ]
        , li [ class "menu-divider" ] []
        , li
            [ classList
                [ ( "menu-marks", True )
                , ( "checked", global.marks )
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
