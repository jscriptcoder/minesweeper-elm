import Html exposing (div, button, text)
import Html.App exposing (program)
import Task
import Time
import Random



main =
  program { init = (model, getTime)
          , view = view
          , update = update
          , subscriptions = (\_ -> Sub.none)
          }



type Msg = Timestamp Float



model = { time = 0
        , list = []
        }



view model =
  div [][ text <| toString model.list ]



update msg model =
  case msg of
    Timestamp time ->
    let
      seed = Random.initialSeed <| round time
      generatorList = Random.list 5 <| Random.int 1 9
      randomList = fst <| Random.step generatorList seed
    in
      ({ model | time = time, list = randomList}, Cmd.none)



getTime =
  Task.perform Timestamp Timestamp Time.now
