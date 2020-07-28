module TopClimber exposing (..)

import Array
import Expect exposing (Expectation)
import Json.Decode as D
import Main
import Test exposing (..)


suite : Test
suite =
    describe "topClimber"
        [ test "take a list of athletes and return the top climber" <|
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
                          , place = 1
                          , place_prev = 100
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
                Expect.equal (Main.topClimber athletes) "NOBODY, James: 99"
        ]
