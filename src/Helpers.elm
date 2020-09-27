module Helpers exposing (..)

import Browser.Dom as Dom
import Http
import Json.Decode
import Task
import Types exposing (Athlete, Gender(..), Msg(..), Nation)



-- HELPERS


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)


getNationsFromAPI : Cmd Msg
getNationsFromAPI =
    Http.get
        { url = "https://data.judobase.org/api/get_json?params[action]=country.get_list"
        , expect = Http.expectJson FetchNations nationsDecoder
        }


getAthletesFromAPI : String -> Cmd Msg
getAthletesFromAPI nationIOC =
    Http.get
        { url = "https://www.ijf.org/internal_api/wrl?category=all&nation=" ++ String.toLower nationIOC
        , expect = Http.expectJson FetchAthletes athletesDecoder
        }


getViewport : Cmd Msg
getViewport =
    Task.perform ViewportResult Dom.getViewport


nationsDecoder : Json.Decode.Decoder (List Nation)
nationsDecoder =
    Json.Decode.map identity
        (Json.Decode.list nationDecoder)


nationDecoder : Json.Decode.Decoder Nation
nationDecoder =
    Json.Decode.map3 Nation
        (Json.Decode.field "id_country" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ioc" Json.Decode.string)


athletesDecoder : Json.Decode.Decoder (List Athlete)
athletesDecoder =
    Json.Decode.map identity
        (Json.Decode.field "feed" (Json.Decode.list athleteDecoder))


athleteDecoder : Json.Decode.Decoder Athlete
athleteDecoder =
    Json.Decode.map7 Athlete
        (Json.Decode.field "family_name" Json.Decode.string)
        (Json.Decode.field "gender" Json.Decode.string)
        (Json.Decode.field "given_name" Json.Decode.string)
        (Json.Decode.field "place" Json.Decode.int)
        (Json.Decode.field "place_prev" Json.Decode.int)
        (Json.Decode.field "sum_points" Json.Decode.int)
        (Json.Decode.field "weight_name" Json.Decode.string)


topAthlete : Gender -> List Athlete -> String
topAthlete gender athletes =
    let
        filterOn =
            case gender of
                Male ->
                    "male"

                Female ->
                    "female"
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
                        a.family_name ++ ", " ++ a.given_name

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
