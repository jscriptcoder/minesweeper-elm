import Html.App as App
import Model exposing (board)
import View exposing (boardHtml)
import Update exposing (boardReducer)

main = 
  App.beginnerProgram {
    model = board, 
    view = boardHtml,
    update = boardReducer
  }