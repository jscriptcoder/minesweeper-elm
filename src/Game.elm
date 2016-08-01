module Game exposing (..)

import Html exposing (div)
import Html.Attributes exposing (class)
import Dialog
import Board


{-
    <div class="game-container">

        <Dialog />

        <Board />

    </div>
-}
view model =
    div [ class "game-container" ]
        [ Dialog.view model
        , Board.view model
        ]