module Board exposing (..)

import Html exposing (div)
import Html.Attributes exposing (class, href)
import Menu
import Header
import Minefield



{-
<div class="board-window window-wrapper-outer">
    <div class="window-wrapper-inner">
        <div class="window-container">
            <div class="title-bar"></div>

            <div class="menu-link-container">
                <a href="#" class="menu-link">Game</a>
            </div>

            <div class="board-wrapper">

                <Menu />

                <Header />

                <Minefield />

            </div>
        </div>
    </div>
</div>
-}
view =
    div [ class "board-window window-wrapper-outer" ]
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar" ] []
                , div [ class "menu-link-container" ]
                    [ div [ class "menu-link" href "#" ] [ text "Game" ]
                    , div [ class "board-wrapper" ]
                        [ Menu.view
                        , Header.view
                        , Minefield.view
                        ]
                    ]
                ]
            ]
        ]