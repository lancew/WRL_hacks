module TopFaller exposing (..)

import Array
import Expect exposing (Expectation)
import Json.Decode as D
import Main
import Test exposing (..)


suite : Test
suite =
    describe "topFaller"
        [ test "take a list of athletes and return the top faller" <|
            \_ ->
                let
                    athletes =
                        [ { given_name = "Joe"
                          , family_name = "BLOGS"
                          , place = 68
                          , place_prev = 69
                          , gender = "male"
                          , sum_points = 2000
                          , weight_name = "foo"
                          }
                        , { given_name = "James"
                          , family_name = "NOBODY"
                          , place = 50
                          , place_prev = 40
                          , gender = "male"
                          , sum_points = 2000
                          , weight_name = "foo"
                          }
                        , { given_name = "Jane"
                          , family_name = "DOE"
                          , place = 50
                          , place_prev = 69
                          , gender = "female"
                          , sum_points = 2000
                          , weight_name = "foo"
                          }
                        ]
                in
                Expect.equal (Main.topFaller athletes) "NOBODY, James: -10"
        ]
