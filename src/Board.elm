module Board exposing (model, view)

import Html exposing (div, text)
import Html.Attributes exposing (class, href)
import Menu
import Header
import Minefield



-- MESSAGES

type Msg
    = MenuMsg Menu.Msg



-- MODEL

type alias Model =
    { level : Int
    , marks: Bool
    , menuOpen: Bool
    , timer: Int
    , minefield : Minefield.Model
    }

model : Model
model =
    { level = 1
    , marks = True
    , menuOpen = False
    , timer = 0
    , minefield = Minefield.model
    }



-- VIEW

view model =
    div [ class "board-window window-wrapper-outer" ]
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar" ] []
                , div [ class "menu-link-container" ]
                    [ div [ class "menu-link", href "#" ] [ text "Game" ] ]
                , div [ class "board-wrapper" ]
                    [ Menu.view model
                    , Header.view model.header
                    , Minefield.view model.minefield
                    ]
                ]
            ]
        ]