module Components.Board exposing
    ( Msg, OutMsg(..)
    , Model, model
    , view, update
    )

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Html.App as App

import Components.Config as Config
import Components.Menu as Menu
import Components.Header as Header
import Components.Minefield as Minefield


-- MESSAGES

type Msg
    = ToggleMenu
    | MenuMsg Menu.Msg
    | HeaderMsg Header.Msg
    | MinefieldMsg Minefield.Msg

type OutMsg
    = MenuOutMsg Menu.Msg

-- MODEL

type alias Model =
    { menu : Menu.Model
    , header : Header.Model
    , minefield : Minefield.Model
    }

model : Model
model =
    { menu = Menu.model
    , header = Header.model
    , minefield = Minefield.model
    }



-- VIEW

view : Model -> Config.Model -> Html Msg
view model config =
    div [ class "board-window window-wrapper-outer" ]
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar" ] []
                , div [ class "menu-link-container" ]
                    [ viewMenuLink model ]
                , div [ class "board-wrapper" ]
                    [ App.map MenuMsg <| Menu.view model.menu config
                    , App.map HeaderMsg <| Header.view model.header config
                    , App.map MinefieldMsg <| Minefield.view model.minefield config
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

update : Msg -> Model -> (Model, Maybe OutMsg)
update msg model =
    case msg of
        ToggleMenu ->
            ({ model | menu = Menu.toggleOpen model.menu }, Nothing)

        MenuMsg menuMsg ->
            let
                menuModel = Menu.update menuMsg model.menu
            in
                ({ model | menu = menuModel }, Just (MenuOutMsg menuMsg))

        HeaderMsg headerMsg ->
            (model, Nothing)

        MinefieldMsg minefieldMsg ->
            (model, Nothing)