module AthletesDecoder exposing (..)

import Array
import Expect exposing (Expectation)
import Json.Decode as D
import Main exposing (athleteDecoder, athletesDecoder)
import Test exposing (..)


type alias Athlete =
    { family_name : String
    , given_name : String
    , place : String
    }




suite : Test
suite =
    describe "Our JSON Parser for athlete"
        [ test "decode an athlete" <|
            \_ ->
                let
                    result =
                        D.decodeString athleteDecoder athleteJson
                in
                case result of
                    Ok record ->
                        Expect.equal record.given_name "Justine"

                    Err err ->
                        Expect.equal "a" "b"
            , test "decode a list of athletes" <|
            \_ ->
                let
                    result =
                        D.decodeString athletesDecoder athletesJson
                in
                case result of
                    Ok record ->
                        let
                            ath =
                                Array.get 0 <| Array.fromList record
                        in
                        case ath of
                            Just athlete ->
                                Expect.equal athlete.given_name "Justine"

                            Nothing ->
                                Expect.equal "a" "b"

                    Err err ->
                        Expect.equal "Failure" "Decoding"
        ]

athleteJson =
    """
{
      "id": "14994_63_10",
      "sum_points": 394,
      "place": 68,
      "place_prev": 69,
      "id_person": "14994",
      "family_name": "BISHOP",
      "given_name": "Justine",
      "gender": "female",
      "timestamp_version": "v1563987346",
      "id_country": "63",
      "country_name": "New Zealand",
      "country_ioc_code": "nzl",
      "id_continent": "4",
      "id_weight": "10",
      "weight_name": "-57",
      "score_parts": [
        {
          "points": 240,
          "competition": {
            "id": "1751",
            "name": "World Championships Senior 2019",
            "date_from": "2019-08-25"
          },
          "place": null,
          "long_place": "1/32"
        },
        {
          "points": 36,
          "competition": {
            "id": "1736",
            "name": "Taipei Asian Open 2019",
            "date_from": "2019-08-03"
          },
          "place": 5,
          "long_place": "5. place"
        },
        {
          "points": 10,
          "competition": {
            "id": "1764",
            "name": "Osaka Grand Slam 2019",
            "date_from": "2019-11-22"
          },
          "place": null,
          "long_place": "participation"
        },
        {
          "points": 6,
          "competition": {
            "id": "1748",
            "name": "Zagreb Grand Prix 2019",
            "date_from": "2019-07-26"
          },
          "place": null,
          "long_place": "participation"
        },
        {
          "points": 6,
          "competition": {
            "id": "1754",
            "name": "Perth Oceania Open 2019",
            "date_from": "2019-11-03"
          },
          "place": null,
          "long_place": "participation"
        },
        null,
        {
          "points": 35,
          "competition": {
            "id": "1597",
            "name": "Perth Oceania Open 2018",
            "date_from": "2018-11-17"
          },
          "place": 2,
          "long_place": "2. place"
        },
        {
          "points": 25,
          "competition": {
            "id": "1715",
            "name": "Lima Panamerican Open 2019",
            "date_from": "2019-03-09"
          },
          "place": 3,
          "long_place": "3. place"
        },
        {
          "points": 18,
          "competition": {
            "id": "1723",
            "name": "Santiago del Chile Panamerican Open 2019",
            "date_from": "2019-03-23"
          },
          "place": 5,
          "long_place": "5. place"
        },
        {
          "points": 18,
          "competition": {
            "id": "1721",
            "name": "Cordoba Panamerican Open 2019",
            "date_from": "2019-03-16"
          },
          "place": 5,
          "long_place": "5. place"
        },
        null,
        null
      ]
    }
"""

athletesJson = """
{
  "feed": [
    {
      "id": "14994_63_10",
      "sum_points": 394,
      "place": 68,
      "place_prev": 69,
      "id_person": "14994",
      "family_name": "BISHOP",
      "given_name": "Justine",
      "gender": "female",
      "timestamp_version": "v1563987346",
      "id_country": "63",
      "country_name": "New Zealand",
      "country_ioc_code": "nzl",
      "id_continent": "4",
      "id_weight": "10",
      "weight_name": "-57",
      "score_parts": [
        {
          "points": 240,
          "competition": {
            "id": "1751",
            "name": "World Championships Senior 2019",
            "date_from": "2019-08-25"
          },
          "place": null,
          "long_place": "1/32"
        },
        {
          "points": 36,
          "competition": {
            "id": "1736",
            "name": "Taipei Asian Open 2019",
            "date_from": "2019-08-03"
          },
          "place": 5,
          "long_place": "5. place"
        },
        {
          "points": 10,
          "competition": {
            "id": "1764",
            "name": "Osaka Grand Slam 2019",
            "date_from": "2019-11-22"
          },
          "place": null,
          "long_place": "participation"
        },
        {
          "points": 6,
          "competition": {
            "id": "1748",
            "name": "Zagreb Grand Prix 2019",
            "date_from": "2019-07-26"
          },
          "place": null,
          "long_place": "participation"
        },
        {
          "points": 6,
          "competition": {
            "id": "1754",
            "name": "Perth Oceania Open 2019",
            "date_from": "2019-11-03"
          },
          "place": null,
          "long_place": "participation"
        },
        null,
        {
          "points": 35,
          "competition": {
            "id": "1597",
            "name": "Perth Oceania Open 2018",
            "date_from": "2018-11-17"
          },
          "place": 2,
          "long_place": "2. place"
        },
        {
          "points": 25,
          "competition": {
            "id": "1715",
            "name": "Lima Panamerican Open 2019",
            "date_from": "2019-03-09"
          },
          "place": 3,
          "long_place": "3. place"
        },
        {
          "points": 18,
          "competition": {
            "id": "1723",
            "name": "Santiago del Chile Panamerican Open 2019",
            "date_from": "2019-03-23"
          },
          "place": 5,
          "long_place": "5. place"
        },
        {
          "points": 18,
          "competition": {
            "id": "1721",
            "name": "Cordoba Panamerican Open 2019",
            "date_from": "2019-03-16"
          },
          "place": 5,
          "long_place": "5. place"
        },
        null,
        null
      ]
    },
    {
      "id": "41132_63_14",
      "sum_points": 182,
      "place": 74,
      "place_prev": 74,
      "id_person": "41132",
      "family_name": "ANDREWS",
      "given_name": "Sydnee",
      "gender": "female",
      "timestamp_version": "v1569858178",
      "id_country": "63",
      "country_name": "New Zealand",
      "country_ioc_code": "nzl",
      "id_continent": "4",
      "id_weight": "14",
      "weight_name": "+78",
      "score_parts": [
        {
          "points": 182,
          "competition": {
            "id": "1754",
            "name": "Perth Oceania Open 2019",
            "date_from": "2019-11-03"
          },
          "place": 7,
          "long_place": "7. place"
        },
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null
      ]
    }
  ]
}
"""