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
import Json.Decode



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
    , athletes : List String
    , error : String
    }


init _ =
    ( { nations = []
      , athletes = [ "Loading Athletes..." ]
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
    | GetAthletes
    | FetchNations (Result Http.Error (List Nation))
    | Foo


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetNations ->
            ( model, getNationsFromAPI )

        GetAthletes ->
            ( { model | athletes = getAthletesFromAPI }, Cmd.none )

        FetchNations result ->
            case result of
                Ok nations ->
                    ( { model | nations = nations }, Cmd.none )

                Err _ ->
                    ( { model | nations = [], error = "--- Error: Problem loading nations from IJF ---" }, Cmd.none )

        Foo ->
            ( model, Cmd.none )



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
                                            { onPress = Just GetAthletes
                                            , label = Element.text nation.name
                                            }
                              }
                            ]
                        }
                    ]
                , column [ padding 5, height fill, width (fillPortion 4), Border.width 1, Border.rounded 5 ]
                    [ Input.button [ Border.width 5, Border.rounded 5, padding 5 ]
                        { label = text "Get Athletes"
                        , onPress = Just GetAthletes
                        }
                    , Element.table [ alignTop, height fill ]
                        { data = List.sort model.athletes
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Athletes")
                              , width = fill
                              , view =
                                    \athlete ->
                                        el [] (Element.text athlete)
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


getAthletesFromAPI =
    [ "Wicks, Lance", "Kano, Jigoro", "Koga, Toshihiko", "Adams, Sam" ]
