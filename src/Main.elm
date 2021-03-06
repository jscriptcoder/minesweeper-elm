module Main exposing (..)

import Html.App exposing (program)
import Components.Game as Game


main : Program Never
main =
    program
        { init = Game.init
        , view = Game.view
        , update = Game.update
        , subscriptions = Game.subscriptions
        }
