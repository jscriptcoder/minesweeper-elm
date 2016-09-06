import Html exposing (div, button, text)
import Html.App exposing (program)
import Task
import Time
import Random
import List
import Array
import Debug

main =
  program { init = (model, getTime)
          , view = view
          , update = update
          , subscriptions = (\_ -> Sub.none)
          }

type Msg = Timestamp Float

model = { time = 0
        , list = []
        , random = []
        }

view model =
  div [][ text <| (toString model.random) ++ " -> " ++ (toString model.list) ]

update msg model =
  case msg of
    Timestamp time ->
    let
      seed = generateSeed time
      generatorList = createGenerator 5 1 5
      randomList = generateRandomList generatorList seed
      uniqueList = sanitizeList randomList 1 5
    in
      ({ model | time = time, list = uniqueList, random = randomList }, Cmd.none)

getTime =
  Task.perform Timestamp Timestamp Time.now

generateSeed time =
  Random.initialSeed <| round time

createGenerator size min max =
  Random.list size <| Random.int min max

generateRandomList generatorList seed =
  fst <| Random.step generatorList seed

sanitizeList list min max =
  doSanitationFrom (Debug.log "initial list" list) [] min max

doSanitationFrom list result min max =
  let
    maybeHead = List.head list
    maybeTail = List.tail list
  in
    case Debug.log "maybe head" maybeHead of
      Just head ->
        case Debug.log "maybe tail:" maybeTail of
          Just tail ->
            if List.member head tail || List.member head result then
              if (head + 1) <= max then
                doSanitationFrom ((head + 1) :: tail) result min max
              else
                doSanitationFrom (min :: tail) result min max
            else
              -- doSanitationFrom tail (head :: result) min max
              doSanitationFrom (Debug.log "next one..." tail) (List.append result [head]) min max
          
          Nothing ->
            Debug.log "final list" result
          
      Nothing ->
        Debug.log "final list" result
