import Html exposing (Html, div, text)
import Html.App exposing (program)


main =
    program { init = ("Hello Minesweeper!!", Cmd.none)
            , view = \model -> div [] [text model]
            , update = \msg model -> (model, Cmd.none)
            , subscriptions = \model -> Sub.none
            }