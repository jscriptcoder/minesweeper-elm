module Menu exposing (Msg, Model, view)

import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Game
import Board



-- MESSAGES

type Msg
    = NewGame
    | LevelBeginner
    | LevelIntermediate
    | LevelExpert
    | OpenCustomDialog
    | CheckMarks



-- MODEL

type alias Model =
    { open : Bool }



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

update : Msg -> Game.Model -> Game.Model
update msg gameModel =
    case msg of
        NewGame ->
            gameModel

        LevelBeginner ->
            { gameModel | 
                config = setLevelBeginner gameModel.config, 
                board = closeBoardMenu gameModel.board }

        LevelIntermediate ->
            { gameModel | 
                config = setLevelIntermediate gameModel.config, 
                board = closeBoardMenu gameModel.board }

        LevelExpert ->
            { gameModel | 
                config = setLevelExpert gameModel.config, 
                board = closeBoardMenu gameModel.board }

        OpenCustomDialog ->

        CheckMarks ->

closeBoardMenu : Board.Model -> Board.Model
closeBoardMenu boardModel =
    let
        menu = boardModel.model
    in
        { boardModel | menu = { menu | open = False } }