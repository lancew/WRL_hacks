module Main exposing (main)

{--}
--}

import Browser as Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, button, div)
import Html.Events exposing (onClick)
import Http



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { nations : List String
    , athletes : List String
    }


init _ =
    ( { nations = [ "Loading Nations..." ]
      , athletes = [ "Loading Athletes..." ]
      }
    , Cmd.none
    )



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = GetNations
    | GetAthletes


update msg model =
    case msg of
        GetNations ->
            ( { model | nations = getNationsFromAPI }, Cmd.none )
        GetAthletes ->
            ( { model | athletes = getAthletesFromAPI }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [ padding 5, height fill, width fill ] <|
        column [ width fill, height fill ]
            [ row [ width fill, padding 10 ]
                [ el
                    [ width fill
                    , alignTop
                    , centerX
                    , Font.center
                    , Font.bold
                    , Font.size 36
                    , Font.family
                        [ Font.serif
                        ]
                    ]
                    (text "International Judo Federation World Ranking List")
                ]
            , row [ padding 5, alignTop, height fill, width fill, spacing 5 ]
                [ column [ padding 5, height fill, width (fillPortion 1), Border.width 1, Border.rounded 5 ]
                    [ Input.button [ Border.width 5, Border.rounded 5, padding 5 ]
                        { label = text "Get Nations"
                        , onPress = Just GetNations
                        }
                    , Element.table
                        [ alignTop, height fill, padding 5 ]
                        { data = List.sort model.nations
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Nations")
                              , width = fill
                              , view =
                                    \nation ->
                                        el [] (Element.text nation)
                              }
                            ]
                        }
                    ]
                , column [ padding 5, height fill, width (fillPortion 4), Border.width 1, Border.rounded 5 ]
                    [ Input.button [ Border.width 5, Border.rounded 5, padding 5 ]
                        { label = text "Get Athletes"
                        , onPress = Just GetAthletes
                        }
                    , Element.table [ alignTop, height fill ]
                        { data = List.sort model.athletes
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Athletes")
                              , width = fill
                              , view =
                                    \athlete ->
                                        el [] (Element.text athlete)
                              }
                            ]
                        }
                    ]
                ]
            , row [ alignBottom, width fill, padding 10 ]
                [ el [ width fill, Font.center ] (text "www.judowrl.com")
                ]
            ]


getNationsFromAPI =
    [ "Australia", "Zimbabwe", "New Zealand" ]

getAthletesFromAPI =
    [ "Wicks, Lance", "Kano, Jigoro", "Koga, Toshihiko", "Adams, Sam" ]
