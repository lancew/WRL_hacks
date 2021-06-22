module AthletesDecoderNew exposing (..)

import Array
import Expect
import Helpers exposing (athleteDecoder2, athletesDecoder2)
import Json.Decode as D
import Test exposing (..)
import Types exposing (Gender(..))

suite : Test
suite =
    describe "JSON Parser for athletes (v2)"
        [ test "decode a list of athletes check first athlete" <|
            \_ ->
                let
                    result =
                        D.decodeString athletesDecoder2 athletesJson
                in
                case result of
                    Ok record ->
                        let
                            ath =
                                Array.get 0 <| Array.fromList record
                        in
                        case ath of
                            Just athlete ->
                                Expect.equal athlete
                                    { given_name = "Jason"
                                    , family_name = "KOSTER"
                                    , place = 83
                                    , place_prev = 0
                                    , gender = Male
                                    , sum_points = 428
                                    , weight_name = "-100"
                                    }

                            Nothing ->
                                Expect.equal "a" "b"

                    Err err ->
                        Expect.fail (D.errorToString err)
                ,  test "decode a single athlete" <|
                    \_ ->
                            case D.decodeString athleteDecoder2 athleteJson of
                                Ok record -> Expect.equal { given_name = "Jason" , family_name = "KOSTER", gender =Male, place = 83, place_prev = 0, sum_points = 428, weight_name = "-100" } record
                                Err err -> Expect.fail (D.errorToString err)
        ]



athleteJson : String
athleteJson =
    """
{
      "family_name": "KOSTER",
      "given_name": "Jason",
      "id_person": "2994",
      "folder": "/2020/02/",
      "name": "2994_1581596599.jpg",
      "picture_filename": "2994_1581596599.jpg",
      "sum_points": "428",
      "place": "83",
      "weight_name": "-100",
      "id_weight": "6",
      "categories": "+90 kg,-100 kg",
      "order_cat_number": "6",
      "personal_picture": "https://www.judobase.org/files/persons//2020/02//2994_1581596599.jpg",
      "wrl": [
        {
          "place": "83",
          "points": "428",
          "weight": "-100",
          "id_weight": "6"
        }
      ]
    }
"""


athletesJson : String
athletesJson =
    """
{
  "competitors": {
    "2994": {
      "family_name": "KOSTER",
      "given_name": "Jason",
      "id_person": "2994",
      "folder": "/2020/02/",
      "name": "2994_1581596599.jpg",
      "picture_filename": "2994_1581596599.jpg",
      "sum_points": "428",
      "place": "83",
      "weight_name": "-100",
      "id_weight": "6",
      "categories": "+90 kg,-100 kg",
      "order_cat_number": "6",
      "personal_picture": "https://www.judobase.org/files/persons//2020/02//2994_1581596599.jpg",
      "wrl": [
        {
          "place": "83",
          "points": "428",
          "weight": "-100",
          "id_weight": "6"
        }
      ]
    },
    "6199": {
      "family_name": "MOCEYAWA",
      "given_name": "Ana",
      "id_person": "6199",
      "folder": "/2019/09/",
      "name": "6199_1568275555.jpg",
      "picture_filename": "6199_1568275555.jpg",
      "sum_points": "6",
      "place": "251",
      "weight_name": "-63",
      "id_weight": "11",
      "categories": "-57 kg,-63 kg",
      "order_cat_number": "13",
      "personal_picture": "https://www.judobase.org/files/persons//2019/09//6199_1568275555.jpg",
      "wrl": [
        {
          "place": "251",
          "points": "6",
          "weight": "-63",
          "id_weight": "11"
        }
      ]
    }
  }
}
"""
