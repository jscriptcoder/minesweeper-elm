module Board exposing (..)

import Html exposing (div, text)
import Html.Attributes exposing (class, href)
import Menu
import Header
import Minefield



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
                    , Header.view model
                    , Minefield.view model
                    ]
                ]
            ]
        ]