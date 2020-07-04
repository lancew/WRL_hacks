module Main exposing (main)

import Browser as Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Http


model =
    { nations = [ "Loading Nations..." ]
    , athletes = [ "Loading Athletes..." ]
    }


main =
    view


subscriptions =
    Sub.none


view =
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
                        [
                          Font.serif
                        ]
                    ]
                    (text "International Judo Federation World Ranking List")
                ]
            , row [ padding 5, alignTop, height fill, width fill, spacing 5 ]
                [ column [ padding 5, height fill, width (fillPortion 1), Border.width 1, Border.rounded 5 ]
                    [ Element.table [ alignTop, height fill ]
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
                    [ Element.table [ alignTop, height fill ]
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
