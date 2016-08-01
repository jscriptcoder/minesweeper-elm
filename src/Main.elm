import Html exposing (Html, div, text)
import Html.App exposing (program)
import Game


main =
    program { init = (Game.model, Cmd.none)
            , view = Game.view
            , update = \msg model -> (model, Cmd.none)
            , subscriptions = \model -> Sub.none
            }