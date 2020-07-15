module NationsDecoder exposing (..)

import Array
import Expect exposing (Expectation)
import Json.Decode as D
import Main exposing (nationDecoder, nationsDecoder)
import Test exposing (..)


type alias Country =
    { id_country : String
    , name : String
    , ioc : String
    }


countryJson =
    """
{"id_country":"194","name":"Afghanistan","ioc":"AFG"}
"""


suite : Test
suite =
    describe "Our JSON Parser for country"
        [ test "decode a country" <|
            \_ ->
                let
                    result =
                        D.decodeString nationDecoder countryJson
                in
                case result of
                    Ok record ->
                        Expect.equal record.ioc "AFG"

                    Err err ->
                        Expect.equal "a" "b"
        , test "decode a countries" <|
            \_ ->
                let
                    result =
                        D.decodeString nationsDecoder countriesJson
                in
                case result of
                    Ok record ->
                        let
                            cty =
                                Array.get 0 <| Array.fromList record
                        in
                        case cty of
                            Just country ->
                                Expect.equal country.ioc "AFG"

                            Nothing ->
                                Expect.equal "a" "b"

                    Err err ->
                        Expect.equal "a" "b"
        ]


countriesJson =
    """
[{"id_country":"194","name":"Afghanistan","ioc":"AFG"},{"id_country":"299","name":"African Judo Union","ioc":"AJU"}]
"""
