module Components.Board exposing (Msg, Model, model, view, update)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Html.App as App

import Components.Menu as Menu
import Components.Header as Header
import Components.Minefield as Minefield



-- MESSAGES

type Msg
    = ToggleMenu
    | MenuMsg Menu.Msg
    | HeaderMsg Header.Msg
    | MinefieldMsg Minefield.Msg



-- MODEL

type alias Model =
    { timer : Int
    , menu : Menu.Model
    , header : Header.Model
    , minefield : Minefield.Model
    }

model : Model
model =
    { timer = 0
    , menu = Menu.model
    , header = Header.model
    , minefield = Minefield.model
    }



-- VIEW

view : Model -> Html Msg
view model =
    div [ class "board-window window-wrapper-outer" ]
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar" ] []
                , div [ class "menu-link-container" ]
                    [ viewMenuLink model ]
                , div [ class "board-wrapper" ]
                    [ App.map MenuMsg <| Menu.view model.menu
                    , App.map HeaderMsg <| Header.view model.header
                    , App.map MinefieldMsg <| Minefield.view model.minefield
                    ]
                ]
            ]
        ]

viewMenuLink : Model -> Html Msg
viewMenuLink model =
    div [ classList [ ("menu-link", True), ("active", model.menu.open) ]
        , href "#"
        , onClick ToggleMenu
        ] [ text "Game" ]



-- UPDATE

update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleMenu ->
            { model | menu = Menu.toggleOpen model.menu }

        MenuMsg menuMsg ->
            model

        HeaderMsg headerMsg ->
            model

        MinefieldMsg minefieldMsg ->
            model