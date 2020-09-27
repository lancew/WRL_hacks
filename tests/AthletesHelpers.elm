module AthletesHelpers exposing (..)

import Array
import Expect exposing (Expectation)
import Helpers
import Json.Decode as D
import Test exposing (..)
import Types exposing (Gender(..), Athlete)


suite : Test
suite =
    describe "topAthlete"
        [ test "take a list of athletes and return the top male" <|
            \_ ->
                let
                    athletes =
                        [ { given_name = "Joe"
                          , family_name = "BLOGS"
                          , place = 68
                          , place_prev = 69
                          , gender = "male"
                          , sum_points = 100
                          , weight_name = "Foo"
                          }
                        , { given_name = "James"
                          , family_name = "NOBODY"
                          , place = 60
                          , place_prev = 69
                          , gender = "male"
                          , sum_points = 100
                          , weight_name = "Foo"
                          }
                        , { given_name = "Jane"
                          , family_name = "DOE"
                          , place = 50
                          , place_prev = 69
                          , gender = "female"
                          , sum_points = 100
                          , weight_name = "Foo"
                          }
                        ]
                in
                Expect.equal (Helpers.topAthlete Male athletes) "NOBODY, James"
        , test "take a list of athletes and return the top female" <|
            \_ ->
                let
                    athletes =
                        [ { given_name = "Joe"
                          , family_name = "BLOGS"
                          , place = 68
                          , place_prev = 69
                          , gender = "male"
                          , sum_points = 100
                          , weight_name = "Foo"
                          }
                        , { given_name = "James"
                          , family_name = "NOBODY"
                          , place = 60
                          , place_prev = 69
                          , gender = "female"
                          , sum_points = 100
                          , weight_name = "Foo"
                          }
                        , { given_name = "Jane"
                          , family_name = "DOE"
                          , place = 50
                          , place_prev = 69
                          , gender = "female"
                          , sum_points = 100
                          , weight_name = "Foo"
                          }
                        ]
                in
                Expect.equal (Helpers.topAthlete Female athletes) "DOE, Jane"
        ]
