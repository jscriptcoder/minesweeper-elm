import Html
import List

model =
  { id = 0 }

main = makeMatrix model 5 10
  |> toString
  |> Html.text

makeMatrix model columns rows =
  let
    len = columns * rows
    models = List.repeat len model
    ids = [1..len]
    modelsWithId = List.map2 (\id model -> { model | id = id }) ids models
  in
    list2Matrix (List.reverse modelsWithId) columns

list2Matrix models columns =
  list2MatrixHelper models columns []

list2MatrixHelper models columns matrix =
  let
    modelsColumn = List.take columns models
  in
    if List.length modelsColumn > 0 then
      let
        newModels = List.drop columns models
        reverseColumn = List.reverse modelsColumn
        newMatrix = reverseColumn :: matrix
      in
        list2MatrixHelper newModels columns newMatrix
    else
      matrix
