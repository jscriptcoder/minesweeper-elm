module Board exposing (model, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, href)
import Menu
import Header
import Minefield



-- MESSAGES

type Msg
    = MenuMsg Menu.Msg



-- MODEL

type alias Model =
    { timer : Int
    , menu : Menu.Model
    , minefield : Minefield.Model
    }

model : Model
model =
    { timer = 0
    , menuOpen = False
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
                    [ div [ class "menu-link", href "#" ] [ text "Game" ] ]
                , div [ class "board-wrapper" ]
                    [ Menu.view model
                    , Header.view model
                    , Minefield.view model.minefield
                    ]
                ]
            ]
        ]