module Update exposing (..)

import Model exposing (..)

type Action = Increment | Decrement

boardReducer : Action -> Board -> Board
boardReducer action board =
  case action of
    Increment -> board + 1
    Decrement -> board - 1