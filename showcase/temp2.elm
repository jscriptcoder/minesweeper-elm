import Html exposing (div, button, hr, text)
import Html.App exposing (program)
import Html.Events exposing (onClick)
import Task


main =
  program
    { init = ({ value = 0, action = "" }, Cmd.none)
    , view = view
    , update = update
    , subscriptions = (\_ -> Sub.none)
    }


view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model.value) ]
    , button [ onClick Increment ] [ text "+" ]
    , hr [] []
    , div [] [ text model.action ]
    ]


type Msg
  = Increment
  | Decrement
  | AfterAction String


update msg model =
  case msg of
    Increment ->
      ({ model | value = model.value + 1 }, after "Going up!")

    Decrement ->
      ({ model | value = model.value - 1 }, after "Going down!")
      
    AfterAction action ->
      ({ model | action = action }, Cmd.none)

after txt =
  Task.perform AfterAction AfterAction (Task.succeed txt)
  
