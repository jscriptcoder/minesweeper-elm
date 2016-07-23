import Html exposing (Html, div)
import Html.App exposing (program)
import Tile


main =
    program { init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
            }