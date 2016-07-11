module View exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Model exposing (..)
import Update exposing (..)

boardHtml : Board -> Html Action
boardHtml board =
    div [] [
        button [ onClick Decrement ] [ text "-" ],
        div [] [ text (toString board) ],
        button [ onClick Increment ] [ text "+" ]
    ]