module AthletesHelpers exposing (..)

import Array
import Expect exposing (Expectation)
import Json.Decode as D
import Main 
import Test exposing (..)


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
                          }
                        , { given_name = "James"
                          , family_name = "NOBODY"
                          , place = 60
                          , place_prev = 69
                          , gender = "male"
                          }
                        , { given_name = "Jane"
                          , family_name = "DOE"
                          , place = 50
                          , place_prev = 69
                          , gender = "female"
                          }
                        ]
                in
                Expect.equal (Main.topAthlete Male athletes) "NOBODY, James"
        , test "take a list of athletes and return the top female" <|
            \_ ->
                let
                    athletes =
                        [ { given_name = "Joe"
                          , family_name = "BLOGS"
                          , place = 68
                          , place_prev = 69
                          , gender = "male"
                          }
                        , { given_name = "James"
                          , family_name = "NOBODY"
                          , place = 60
                          , place_prev = 69
                          , gender = "female"
                          }
                        , { given_name = "Jane"
                          , family_name = "DOE"
                          , place = 50
                          , place_prev = 69
                          , gender = "female"
                          }
                        ]
                in
                Expect.equal (Main.topAthlete Female athletes) "DOE, Jane"
        ]
