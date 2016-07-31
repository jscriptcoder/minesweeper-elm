module Header exposing (..)

import Html exposing (div)
import Html.Attributes exposing (class)



{-
<div class="header-wrapper">
    <div class="header-container">

        <div class="header">
            <div class="mine-count numbers">
                <div class="digit hundres t0"></div>
                <div class="digit tens t0"></div>
                <div class="digit ones t0"></div>
            </div>

            <div class="reset-button face-smile"></div>

            <div class="timer numbers">
                <div class="digit hundres t0"></div>
                <div class="digit tens t0"></div>
                <div class="digit ones t0"></div>
            </div>

        </div>
    </div>
</div>
-}
view = 
    div [ class "header-wrapper" ]
        [ div [ class "header-container" ]
            [ div [ class "header" ]
                [ div [ class "mine-count numbers" ]
                    [ div [ class "digit hundres t0" ] []
                    , div [ class "digit tens t0" ] []
                    , div [ class "digit ones t0" ] []
                    ]
                , div [ class "reset-button face-smile" ] []
                , div [ class "timer numbers" ]
                    [ div [ class "digit hundres t0" ] []
                    , div [ class "digit tens t0" ] []
                    , div [ class "digit ones t0" ] []
                    ]
                ]
            ]
        ]