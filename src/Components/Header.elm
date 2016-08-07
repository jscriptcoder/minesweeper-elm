module Header exposing (view)

import Html exposing (div)
import Html.Attributes exposing (class)



-- VIEW

view model = 
    div [ class "header-wrapper" ]
        [ div [ class "header-container" ]
            [ div [ class "header" ]
                [ viewMineCount model
                , div [ class "reset-button face-smile" ] []
                , viewTimer model
                ]
            ]
        ]

viewMineCount model =
    div [ class "mine-count numbers" ]
        [ div [ class "digit hundres t0" ] []
        , div [ class "digit tens t0" ] []
        , div [ class "digit ones t0" ] []
        ]

viewTimer model =
    div [ class "timer numbers" ]
        [ div [ class "digit hundres t0" ] []
        , div [ class "digit tens t0" ] []
        , div [ class "digit ones t0" ] []
        ]