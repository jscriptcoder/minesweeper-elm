import Html exposing (Html, div, span, button, text)
import Html.Events exposing (onClick)
import Html.App as App
import Debug

main : Program Never
main =
  App.program { init = (model, Cmd.none)
              , view = view
              , update = update
              , subscriptions = subscriptions
              }



-- GrandChild Component

type MsgGrandChild = ClickGrandChild

type alias ModelGrandChild = 
  { text : String
  }

modelGrandChild : ModelGrandChild
modelGrandChild = 
  { text = ":-)"
  }

viewGrandChild : ModelGrandChild -> Html MsgGrandChild
viewGrandChild model = 
  span [] 
    [ text model.text
    , button [ onClick ClickGrandChild ] [ text "click grandchild" ]
    ]

updateGrandChild : MsgGrandChild -> ModelGrandChild -> (ModelGrandChild, Cmd MsgGrandChild)
updateGrandChild msg model = 
  case msg of
    ClickGrandChild ->
      (Debug.log "ClickGrandChild" model, Cmd.none)

subscriptionsGrandChild : ModelGrandChild -> Sub MsgGrandChild
subscriptionsGrandChild model = 
  Sub.none

-- End GrandChild



-- Child Component

type MsgChild
  = ClickChild
  | MsgGrandChild' MsgGrandChild

type alias ModelChild = 
  { text : String
  , modelGrandChild : ModelGrandChild
  }

modelChild : ModelChild
modelChild = 
  { text = "Elm!"
  , modelGrandChild = modelGrandChild
  }

viewChild : ModelChild -> Html MsgChild
viewChild model = 
  span [] 
    [ text model.text
    , button [ onClick ClickChild ] [ text "click child" ]
    , span [] [ text ", " ]
    , App.map MsgGrandChild' <| viewGrandChild model.modelGrandChild
    ]

updateChild : MsgChild -> ModelChild -> (ModelChild, Cmd MsgChild)
updateChild msg model = 
  case msg of
    ClickChild ->
      (Debug.log "ClickChild" model, Cmd.none)
    
    MsgGrandChild' msgGrandChild ->
      let
        (modelGrandChild, cmdGrandChild) = updateGrandChild msgGrandChild model.modelGrandChild
      in
        ( { model | modelGrandChild = modelGrandChild }
        , Cmd.batch
            [ Cmd.map MsgGrandChild' cmdGrandChild
            ]
        )

subscriptionsChild : ModelChild -> Sub MsgChild
subscriptionsChild model = 
  Sub.batch
    [ Sub.map MsgGrandChild' <| subscriptionsGrandChild model.modelGrandChild
    ]

-- End Child



-- Parent Component

type Msg
  = ClickParent 
  | MsgChild' MsgChild

type alias Model = 
  { text : String
  , modelChild : ModelChild
  }

model : Model
model = 
  { text = "Hello"
  , modelChild = modelChild
  }

view : Model -> Html Msg
view model = 
  div [] 
    [ text model.text
    , button [ onClick ClickParent ] [ text "click parent" ]
    , span [] [ text ", " ]
    , App.map MsgChild' <| viewChild model.modelChild
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    ClickParent ->
      (Debug.log "ClickParent" model, Cmd.none)
    MsgChild' msgChild ->
      let
        (modelChild, cmdChild) = updateChild msgChild model.modelChild
      in
        ( { model | modelChild = modelChild }
        , Cmd.batch
            [ Cmd.map MsgChild' cmdChild
            ]
        )

subscriptions : Model -> Sub Msg
subscriptions model = 
  Sub.batch
    [ Sub.map MsgChild' <| subscriptionsChild model.modelChild
    ]
 
-- End Parent
