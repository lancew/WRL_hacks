module Helpers exposing (..)

import Browser.Dom as Dom
import Http
import Json.Decode as D exposing (succeed)
import Json.Decode.Pipeline as P exposing (required, hardcoded)
import String
import Task
import Types exposing (Athlete, Gender(..), Msg(..), Nation)
import Dict



-- HELPERS


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)


getNationsFromAPI : Cmd Msg
getNationsFromAPI =
    Http.get
        { url = "https://data.ijf.org/api/get_json?params[action]=country.get_list"
        , expect = Http.expectJson FetchNations nationsDecoder
        }


getAthletesFromAPI : String -> Cmd Msg
getAthletesFromAPI nationIOC =
    Http.get
        { url = "https://data.ijf.org/api/get_json?params[action]=country.competitors_list&params[sort]=1&params[id_country]=" ++ String.toLower nationIOC
        , expect = Http.expectJson FetchAthletes athletesDecoder2
        }


getViewport : Cmd Msg
getViewport =
    Task.perform ViewportResult Dom.getViewport


nationsDecoder : D.Decoder (List Nation)
nationsDecoder =
    D.map identity
        (D.list nationDecoder)


nationDecoder : D.Decoder Nation
nationDecoder =
    succeed Nation
        |> required "id_country" D.string
        |> required "name" D.string
        |> required "ioc" D.string

{--
athletesDecoder : D.Decoder (List Athlete)
athletesDecoder =
    D.map identity
        (D.field "feed" (D.list athleteDecoder))


athleteDecoder : D.Decoder Athlete
athleteDecoder =
    D.map7 Athlete
        (D.field "family_name" D.string)
        (D.field "gender" D.string)
        (D.field "given_name" D.string)
        (D.field "place" D.int)
        (D.field "place_prev" D.int)
        (D.field "sum_points" D.int)
        (D.field "weight_name" D.string)

--}

athletesDecoder2 =
   D.map identity
       (D.field "competitors" peopleDecoder)

peopleDecoder =
    D.keyValuePairs athleteDecoder2 |> D.map ( List.map Tuple.second )


athleteDecoder2 : D.Decoder Athlete
athleteDecoder2 =
    succeed Athlete
        |> required "family_name" D.string
        |> required "weight_name" (D.string |> D.andThen stringWeightNameToGenderDecoder )
        |> required "given_name" D.string
        |> required "place" (D.string |> D.andThen stringToIntDecoder )
        |> hardcoded 0
        |> required "sum_points" (D.string |> D.andThen stringToIntDecoder )
        |> required "weight_name" D.string


dictToList competitors =
    Dict.toList competitors

stringWeightNameToGenderDecoder : String -> D.Decoder Gender
stringWeightNameToGenderDecoder gender =
    case gender of
        "+100" -> D.succeed Male
        "-100" -> D.succeed Male
        "-90" -> D.succeed Male
        "-81" -> D.succeed Male
        "-73" -> D.succeed Male
        "-66" -> D.succeed Male
        "-60" -> D.succeed Male
        _ -> D.succeed Female

stringToIntDecoder : String -> D.Decoder Int
stringToIntDecoder year =
    case String.toInt year of
        Just value ->
            D.succeed value

        Nothing ->
            D.fail "Invalid integer"


topAthlete gender athletes =
    let
        filterOn =
            case gender of
                Male ->
                    Male

                Female ->
                    Female
    in
    List.filter
        (\ath ->
            ath.gender == filterOn
        )
        athletes
        |> List.sortBy .place
        |> List.head
        |> (\x ->
                case x of
                    Just a ->
                        a.family_name ++ ", " ++ a.given_name ++ " (" ++ String.fromInt a.place ++ ")"

                    _ ->
                        ""
           )


topClimber : List Athlete -> String
topClimber athletes =
    athletes
        |> List.sortBy (\x -> x.place - x.place_prev)
        |> List.head
        |> (\x ->
                case x of
                    Just a ->
                        a.family_name
                            ++ ", "
                            ++ a.given_name
                            ++ ": "
                            ++ String.fromInt (a.place_prev - a.place)

                    _ ->
                        ""
           )


topFaller : List Athlete -> String
topFaller athletes =
    athletes
        |> List.sortBy (\x -> x.place_prev - x.place)
        |> List.head
        |> (\x ->
                case x of
                    Just a ->
                        a.family_name
                            ++ ", "
                            ++ a.given_name
                            ++ ": "
                            ++ String.fromInt (a.place_prev - a.place)

                    _ ->
                        ""
           )
