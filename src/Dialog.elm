module Dialog exposing (..)

import Html exposing (div, p, label, input, text)
import Html.Attributes exposing (class, type, value)



{-
<div class="custom-level-dialog window-wrapper-outer">
    <div class="window-wrapper-inner">
        <div class="window-container">
            <div class="title-bar"></div>
            <div class="content">
                <div class="fields">
                    <p>
                        <label>Height:</label>
                        <input class="form-textbox custom-height" type="text">
                    </p>
                    <p>
                        <label>Width:</label>
                        <input class="form-textbox custom-width" type="text">
                    </p>
                    <p>
                        <label>Mines:</label>
                        <input class="form-textbox custom-mines" type="text">
                    </p>
                </div>
                <div class="buttons">
                    <input class="form-button ok-btn" type="button" value="OK">
                    <input class="form-button cancel-btn" type="button" value="Cancel">
                </div>
            </div>
        </div>
    </div>
</div>
-}
view =
    div [ class "custom-level-dialog window-wrapper-outer" ] 
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar"] []
                , div [ class "content" ]
                    [ div [ class "fields" ]
                        [ p []
                            [ label [] [ text "Height:"]
                            , input [ class "form-textbox custom-height"
                                    , type "text"
                                    ] []
                            ]
                        , p []
                            [ label [] [ text "Width:"]
                            , input [ class "form-textbox custom-height"
                                    , type "text"
                                    ] []
                        , p []
                            [ label [] [ text "Mines:"]
                            , input [ class "form-textbox custom-height"
                                    , type "text"
                                    ] []
                        ]
                    , div [ class "buttons" ]
                        [ input [ class "form-button ok-btn"
                                , type "button"
                                , value "OK"
                                ] []
                        , input [ class "form-button cancel-btn"
                                , type "button"
                                , value "Cancel"
                                ] []
                        ] 
                    ]
                ]
            ]
        ]