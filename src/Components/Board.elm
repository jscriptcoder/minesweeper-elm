module Components.Board
    exposing
        ( Msg(..)
        , Model
        , model
        , view
        , update
        , subscriptions
        , createMinefield
        )

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Html.App as App
import Components.Global as Global
import Components.Menu as Menu
import Components.Header as Header
import Components.Minefield as Minefield
import Components.Cell as Cell


-- MESSAGES


type Msg
    = ToggleMenu
    | MenuMsg Menu.Msg
    | HeaderMsg Header.Msg
    | MinefieldMsg Minefield.Msg



-- MODEL


type alias Model =
    { menu : Menu.Model
    , header : Header.Model
    , minefield : Minefield.Model
    }


model : Model
model =
    { menu = Menu.model
    , header = Header.model
    , minefield = Minefield.model
    }



-- VIEW


view : Model -> Global.Model -> Html Msg
view model global =
    div [ class "board-window window-wrapper-outer" ]
        [ div [ class "window-wrapper-inner" ]
            [ div [ class "window-container" ]
                [ div [ class "title-bar" ] []
                , div [ class "menu-link-container" ]
                    [ viewMenuLink model ]
                , div [ class "board-wrapper" ]
                    [ App.map MenuMsg <| Menu.view model.menu global
                    , App.map HeaderMsg <| Header.view model.header global
                    , App.map MinefieldMsg <| Minefield.view model.minefield global
                    ]
                ]
            ]
        ]


viewMenuLink : Model -> Html Msg
viewMenuLink model =
    div
        [ classList [ ( "menu-link", True ), ( "active", model.menu.open ) ]
        , href "#"
        , onClick ToggleMenu
        ]
        [ text "Game" ]



-- UPDATE


update : Msg -> Model -> Global.Model -> Model
update msg model global =
    case msg of
        ToggleMenu ->
            { model | menu = Menu.toggleOpen model.menu }

        MenuMsg menuMsg ->
            let
                menuModel =
                    Menu.update menuMsg model.menu
            in
                { model | menu = menuModel }

        HeaderMsg headerMsg ->
            let
                headerModel =
                    Header.update headerMsg model.header

                newModel =
                    { model | header = headerModel }
            in
                processHeaderMsg headerMsg newModel global

        MinefieldMsg minefieldMsg ->
            let
                ( newMinefield, maybeNewCell ) =
                    Minefield.update minefieldMsg model.minefield global
            in
                case maybeNewCell of
                    Just newCell ->
                        if Global.isDone newMinefield.opened global then
                            { model
                                | minefield = newMinefield
                                , header = coolHeaderFace model.header
                            }
                        else
                            { model
                                | minefield = newMinefield
                                , header =
                                    processMinefieldForHeader
                                        newCell
                                        model.header
                            }

                    Nothing ->
                        { model | minefield = newMinefield }



-- SUBSCRIPTIONS


subscriptions : Model -> Global.Model -> Sub Msg
subscriptions model global =
    let
        header =
            model.header
    in
        Sub.map HeaderMsg <| Header.subscriptions header global



-- Helpers


createMinefield : Model -> Global.Model -> Model
createMinefield model global =
    { model
        | minefield = Minefield.create global
        , header = Header.update Header.ResetGame model.header
    }


processHeaderMsg : Header.Msg -> Model -> Global.Model -> Model
processHeaderMsg headerMsg model global =
    if headerMsg == Header.ResetGame then
        createMinefield model global
    else
        model


processMinefieldForHeader : Cell.Model -> Header.Model -> Header.Model
processMinefieldForHeader cell header =
    case cell.state of
        Cell.Pressed ->
            { header | face = Header.Surprised }

        Cell.Opened ->
            { header | face = Header.Smile }

        Cell.MineHit ->
            { header | face = Header.Sad }

        Cell.Flag ->
            { header
                | flags = header.flags + 1
                , face = Header.Smile
            }

        _ ->
            if cell.prevState == Cell.Flag then
                { header
                    | flags = header.flags - 1
                    , face = Header.Smile
                }
            else
                { header | face = Header.Smile }


coolHeaderFace : Header.Model -> Header.Model
coolHeaderFace header =
    { header | face = Header.Cool }
