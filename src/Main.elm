module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


main =
    Element.layout [ padding 5, height fill, width fill ] <|
        column [ width fill, height fill ]
            [ row [ width fill, padding 10 ]
                [ el [ width fill, alignTop, centerX, Font.center ] (text "International Judo Federation World Ranking List")
                ]
            , row [ padding 5, alignTop, height fill, width fill ]
                [ column [ padding 5, height fill, width (fillPortion 1), Border.width 1, Border.rounded 5 ]
                    [ el [ alignTop, width fill, height fill ] (text "Nations")
                    ]
                , column [ padding 5, height fill,  width (fillPortion 4), Border.width 1, Border.rounded 5 ]
                    [ el [ alignTop, width fill, height fill ] (text "Right Content")
                    ]
                ]
            , row [ alignBottom, width fill, padding 10 ]
                [ el [ width fill, Font.center ] (text "www.judowrl.com")
                ]
            ]
