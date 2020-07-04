module Main exposing (main)

import Element exposing (..)


main =
    Element.layout []
        <|
        column [][
            row[][
                text "Header"
            ]
            , row [][
                text "content"
            ]
            , row [][
                text "footer"
            ]
        ]

