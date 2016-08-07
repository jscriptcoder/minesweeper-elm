import Html exposing (Html, div, text)
import Html.App exposing (program)
import Components.Game

main : Program Never
main =
    program { init = (Game.model, Cmd.none)
            , view = Game.view
            , update = \msg model -> (model, Cmd.none)
            , subscriptions = \model -> Sub.none
            }