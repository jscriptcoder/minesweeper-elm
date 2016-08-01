module Dialog exposing (view)

import Html exposing (div, p, label, input, text)
import Html.Attributes exposing (class, type', value)



-- VIEW

view model =
    div [ class "custom-level-dialog window-wrapper-outer" ] 
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar"] []
                , div [ class "content" ]
                    [ viewFields model
                    , viewButtons model
                    ]
                ]
            ]
        ]

viewFields model =
    div [ class "fields" ]
        [ p []
            [ label [] [ text "Height:"]
            , input [ class "form-textbox custom-height"
                    , type' "text"
                    ] []
            ]
        , p []
            [ label [] [ text "Width:"]
            , input [ class "form-textbox custom-height"
                    , type' "text"
                    ] []
            ]
        , p []
            [ label [] [ text "Mines:"]
            , input [ class "form-textbox custom-height"
                    , type' "text"
                    ] []
            ]
        ]

viewButtons model =
    div [ class "buttons" ]
        [ input [ class "form-button ok-btn"
                , type' "button"
                , value "OK"
                ] []
        , input [ class "form-button cancel-btn"
                , type' "button"
                , value "Cancel"
                ] []
        ]
