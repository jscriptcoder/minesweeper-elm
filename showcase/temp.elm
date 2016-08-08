import Html exposing (Html, div, hr, label, input, button, br, text)
import Html.Attributes exposing (type', value)
import Html.Events exposing (onInput, onClick)
import Html.App as App
import String
import Result



-- UTIL


toInt : String -> Int
toInt strNum =
  strNum
    |> String.toInt
    |> Result.withDefault 0


-- MESSAGE


type MsgTemp
  = OnRowsChange String
  | OnColumnsChange String


type Msg
  = OnTempChange MsgTemp
  | OnOK



-- MODEL


type alias Temp =
  { rows : Int
  , columns : Int
  }
  
type alias Model =
  { rows : Int
  , columns : Int
  , temp : Temp
  }


-- UPDATE


updateTemp : MsgTemp -> Temp -> Temp
updateTemp msg temp =
  case msg of
    OnRowsChange strNum ->
      { temp | rows = toInt strNum }

    OnColumnsChange strNum ->
      { temp | columns = toInt strNum }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnTempChange tempMsg ->
      ({ model | temp = updateTemp tempMsg model.temp}, Cmd.none)
    
    OnOK ->
      ({ model | 
          rows = model.temp.rows,
          columns = model.temp.columns
        }, Cmd.none)


-- VIEW

viewTemp : Temp -> Html MsgTemp
viewTemp temp =
  div []
    [ label [] [ text "Rows:"]
    , input
        [ type' "number"
        , value (toString temp.rows)
        , onInput OnRowsChange
        ] []
    , br [] []
    , label [] [ text "Columns:" ]
    , input
        [ type' "number"
        , value (toString temp.columns)
        , onInput OnColumnsChange
        ] []
    ]


view : Model -> Html Msg
view model =
  div []
    [ App.map OnTempChange (viewTemp model.temp)
    , hr [] []
    , button [ onClick OnOK ] [ text "OK" ]
    , hr [] []
    , div [] [ text ("Final: [" ++ toString model.rows ++ ", " ++ toString model.columns ++ "]") ]
    ]



-- MAIN


main : Program Never
main =
  App.program
    { init = (Model 0 0 (Temp 5 5), Cmd.none)
    , view = view
    , update = update
    , subscriptions = (\_-> Sub.none)
    }
