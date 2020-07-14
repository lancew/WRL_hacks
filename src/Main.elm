module Main exposing (main)

import Browser as Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html, button, div)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (errorToString)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { nations : List Nation
    , athletes : List Athlete
    , error : String
    }


init _ =
    ( { nations = []
      , athletes = []
      , error = ""
      }
    , getNationsFromAPI
    )



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = GetNations
    | GetAthletes String
    | FetchNations (Result Http.Error (List Nation))
    | FetchAthletes (Result Http.Error (List Athlete))
    | Test String


update msg model =
    case msg of
        GetNations ->
            ( model, getNationsFromAPI )

        GetAthletes nationID ->
            ( model, getAthletesFromAPI )

        FetchNations result ->
            case result of
                Ok nations ->
                    ( { model | nations = nations }, Cmd.none )

                Err _ ->
                    ( { model | nations = [], error = "--- Error: Problem loading nations from IJF ---" }, Cmd.none )

        FetchAthletes result ->
            case result of
                Ok athletes ->
                    ( { model | athletes = [], error = "I dunno what I am doing" }, Cmd.none )

                Err theError ->
                    case theError of
                        Http.BadUrl _ ->
                            ( { model | athletes = [], error = "--- Error: Problem loading athletes from IJF. Bad URL ---" }, Cmd.none )

                        Http.Timeout ->
                            ( { model | athletes = [], error = "--- Error: Problem loading athletes from IJF. Timeout ---" }, Cmd.none )

                        Http.NetworkError ->
                            ( { model | athletes = [], error = "--- Error: Problem loading athletes from IJF. Network Error ---" }, Cmd.none )

                        Http.BadStatus _ ->
                            ( { model | athletes = [], error = "--- Error: Problem loading athletes from IJF. Bad Status ---" }, Cmd.none )

                        Http.BadBody _ ->
                            ( { model | athletes = [], error = "--- Error: Problem loading athletes from IJF. Bad Body ---" }, Cmd.none )

        Test data ->
            ( { model | error = data }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [ padding 5, height fill, width fill ] <|
        column [ width fill, height fill ]
            [ row [ width fill, padding 10 ]
                [ el
                    [ width fill
                    , alignTop
                    , centerX
                    , Font.center
                    , Font.bold
                    , Font.size 36
                    , Font.family
                        [ Font.serif
                        ]
                    ]
                    (text "International Judo Federation World Ranking List")
                ]
            , row [ width fill ]
                [ el [ width fill, Font.center, Font.color (Element.rgb 1 0 0) ] (text model.error)
                ]
            , row [ padding 5, alignTop, height fill, width fill, spacing 5 ]
                [ column [ padding 5, height fill, width (fillPortion 1), Border.width 1, Border.rounded 5 ]
                    [ Element.table
                        [ alignTop, height fill, padding 5 ]
                        { data = model.nations
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Nations")
                              , width = fill
                              , view =
                                    \nation ->
                                        Input.button []
                                            { onPress = Just (GetAthletes nation.id_country)
                                            , label = Element.text (nation.name ++ " - " ++ nation.id_country)
                                            }
                              }
                            ]
                        }
                    ]
                , column [ padding 5, height fill, width (fillPortion 4), Border.width 1, Border.rounded 5 ]
                    [ Element.table [ alignTop, height fill ]
                        { data = model.athletes
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Athletes")
                              , width = fill
                              , view =
                                    \athlete ->
                                        el [] (Element.text athlete.family_name)
                              }
                            ]
                        }
                    ]
                ]
            , row [ alignBottom, width fill, padding 10 ]
                [ el [ width fill, Font.center ] (text "www.judowrl.com")
                ]
            ]


getNationsFromAPI =
    Http.get
        { url = "https://data.judobase.org/api/get_json?params[action]=country.get_list"
        , expect = Http.expectJson FetchNations nationsDecoder
        }


nationDecoder =
    Json.Decode.map3 Nation
        (Json.Decode.field "id_country" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ioc" Json.Decode.string)


nationsDecoder =
    Json.Decode.map identity
        (Json.Decode.list nationDecoder)


type alias Nation =
    { id_country : String, name : String, ioc : String }


type alias Athlete =
    { family_name : String, given_name : String, place : String }


getAthletesFromAPI =
    Http.get
        { url = "https://data.ijf.org/api/get_json?params[action]=country.competitors_list&params[id_country]=166"
        , expect = Http.expectJson FetchAthletes athletesDecoder
        }


athleteDecoder =
    Json.Decode.map3 Athlete
        (Json.Decode.field "family_name" Json.Decode.string)
        (Json.Decode.field "given_name" Json.Decode.string)
        (Json.Decode.field "place" Json.Decode.string)


athletesDecoder =
    Json.Decode.map identity
        (Json.Decode.list athleteDecoder)



{--
Info on nation: https://data.ijf.org/api/get_json?access_token=&params[action]=country.basic_info&params[__ust]=&params[id_country]=156
Athletes from country: https://data.ijf.org/api/get_json?access_token=&params[action]=country.competitors_list&params[__ust]=&params[id_country]=156



--}
