module Components.Board exposing
    ( Msg, OutMsg(..)
    , Model, model
    , view, update
    )

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Html.App as App

import Components.Menu as Menu
import Components.Header as Header



-- MESSAGES

type Msg
    = ToggleMenu
    | MenuMsg Menu.Msg
    | HeaderMsg Header.Msg

type OutMsg = OpenCustomDialog

-- MODEL

type alias Model =
    { timer : Int
    , menu : Menu.Model
    , header : Header.Model
    }

model : Model
model =
    { timer = 0
    , menu = Menu.model
    , header = Header.model
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
                ( menuModel 
                , menuOutMsg
                ) = Menu.update menuMsg model.menu
            in
                ({ model | menu = menuModel }, Maybe.map menu2boardOutMsg menuOutMsg)

        HeaderMsg headerMsg ->
            (model, Nothing)

menu2boardOutMsg : Menu.OutMsg -> OutMsg
menu2boardOutMsg menuOutMsg =
    case menuOutMsg of
        Menu.OpenCustomDialog -> OpenCustomDialog