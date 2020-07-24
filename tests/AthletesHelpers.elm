module AthletesHelpers exposing (..)

import Array
import Expect exposing (Expectation)
import Json.Decode as D
import Main exposing (topMale)
import Test exposing (..)


suite : Test
suite =
    describe "topMale"
        [ test "take a list of athletes and return the top male" <|
            \_ ->
                let
                    athletes =
                        [ { given_name = "Joe"
                          , family_name = "BLOGS"
                          , place = 68
                          , place_prev = 69
                          , gender = "male"
                          }
                          ,{ given_name = "James"
                          , family_name = "NOBODY"
                          , place = 60
                          , place_prev = 69
                          , gender = "male"
                          },
                          { given_name = "Jane"
                          , family_name = "DOE"
                          , place = 50
                          , place_prev = 69
                          , gender = "female"
                          }
                        ]
                in
                Expect.equal (topMale athletes) "NOBODY, James"
        ]
