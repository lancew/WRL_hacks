module Main exposing (main)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


main =
    Element.layout [ padding 5, height fill, width fill ] <|
        column [ width fill, height fill ]
            [ row [ width fill, padding 10 ]
                [ placeholder [ width fill, alignTop ] "Header"
                ]
            , row [ padding 5, alignTop, height fill, width fill ]
                [ column [ padding 5, height fill, width (fillPortion 1) ]
                    [ placeholder [ alignTop, width fill, height fill ] "Left Content"
                    ]
                , column [ padding 5, height fill, width (fillPortion 4) ]
                    [ placeholder [ alignTop, width fill, height fill ] "Right Content"
                    ]
                ]
            , row [ alignBottom, width fill, padding 10 ]
                [ placeholder [ width fill ] "Footer"
                ]
            ]


wireframeTheme =
    { bg = rgb 0.9 0.9 0.9
    , frame = rgb 0.5 0.5 0.5
    , text = rgb 0.3 0.3 0.3
    }


placeholder : List (Attribute msg) -> String -> Element msg
placeholder attr name =
    text name
        |> el
            [ Border.rounded 5
            , Border.dotted
            , Border.color wireframeTheme.frame
            , Border.width 2
            , height fill
            , width fill
            , padding 20
            , Background.color wireframeTheme.bg
            , Font.center
            , Font.color wireframeTheme.text
            ]
        |> el attr
