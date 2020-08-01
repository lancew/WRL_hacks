module Main exposing (Gender, athleteDecoder, athletesDecoder, main, nationDecoder, nationsDecoder, topAthlete, topClimber, topFaller)

import Browser as Browser
import Browser.Dom as Dom
import Browser.Events as Events
import Countries
import Element exposing (alignBottom, alignLeft, alignRight, alignTop, centerX, centerY, column, el, fill, fillPortion, height, padding, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input
import Html exposing (Html, button)
import Html.Attributes exposing (list)
import Http
import Json.Decode
import Task



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
    , nation : String
    , athletes : List Athlete
    , error : String
    , device : Element.Device
    }



-- OTHER TYPES


type Gender
    = Male
    | Female


type alias Nation =
    { id_country : String
    , name : String
    , ioc : String
    }


type alias Athlete =
    { family_name : String
    , gender : String
    , given_name : String
    , place : Int
    , place_prev : Int
    , sum_points : Int
    , weight_name : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { nations = []
      , athletes = []
      , error = ""
      , nation = ""
      , device =
                
                { class = Element.Desktop
                , orientation = Element.Landscape
                }
                
      }
    , getNationsFromAPI
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ Events.onResize (\values -> SetScreenSize values) ]



-- UPDATE


type Msg
    = GetAthletes String
    | FetchNations (Result Http.Error (List Nation))
    | FetchAthletes (Result Http.Error (List Athlete))
    | SetScreenSize Int Int
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetAthletes nationIOC ->
            ( { model | nation = nationIOC }, getAthletesFromAPI nationIOC )

        FetchNations result ->
            case result of
                Ok nations ->
                    ( { model | nations = nations, error = "" }, Cmd.none )

                Err _ ->
                    ( { model | nations = [], error = "--- Error: Problem loading nations from IJF ---" }, Cmd.none )

        FetchAthletes result ->
            case result of
                Ok athletes ->
                    ( { model | athletes = athletes, error = "" }, resetViewport )

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

        SetScreenSize x y ->
            let
                classifiedDevice =
                    Element.classifyDevice
                        { width = x
                        , height = y
                        }
            in
            ( { model | device = classifiedDevice }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    case model.device.class of
        Element.Phone ->
            case model.device.orientation of
                Element.Portrait ->
                    viewPhonePortrait model

                Element.Landscape ->
                    viewPhoneLandscape model

        Element.Tablet ->
            viewDesktop model

        _ ->
            viewDesktop model


viewDesktop : Model -> Html Msg
viewDesktop model =
    Element.layout [ height fill, width fill, Background.gradient { angle = 3.14, steps = [ Element.rgb255 67 69 122, Element.rgb255 54 51 93 ] } ] <|
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
                    , Font.color (Element.rgb255 255 255 255)
                    ]
                    (text "International Judo Federation World Ranking List")
                ]
            , row [ width fill ]
                [ el [ width fill, Font.center, Font.color (Element.rgb 1 0 0) ] (text model.error)
                ]
            , row [ padding 5, alignTop, height fill, width fill, spacing 5, Background.color (Element.rgb255 226 226 226) ]
                [ column [ padding 5, height fill, width (fillPortion 1), Border.width 1, Border.rounded 5, Background.color (Element.rgb255 255 255 255) ]
                    [ Element.table
                        [ alignTop, height fill, padding 5 ]
                        { data = model.nations
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Nations")
                              , width = fill
                              , view =
                                    \nation ->
                                        Input.button []
                                            { onPress = Just (GetAthletes nation.ioc)
                                            , label =
                                                let
                                                    flag =
                                                        case Countries.fromCode nation.ioc of
                                                            Just nat ->
                                                                nat.flag

                                                            Nothing ->
                                                                ""
                                                in
                                                Element.text
                                                    (flag
                                                        ++ " "
                                                        ++ nation.name
                                                        ++ " - "
                                                        ++ nation.ioc
                                                    )
                                            }
                              }
                            ]
                        }
                    ]
                , column [ padding 5, height fill, width (fillPortion 4), Border.width 1, Border.rounded 5, Background.color (Element.rgb255 255 255 255) ]
                    [ row [ width fill, padding 10 ]
                        [ el [ centerX ]
                            (text
                                (case Countries.fromCode model.nation of
                                    Just nat ->
                                        nat.name

                                    Nothing ->
                                        model.nation
                                )
                            )
                        ]
                    , row [ width fill, padding 10 ]
                        [ el [ alignLeft ] (text ("Top Male: " ++ topAthlete Male model.athletes))
                        , el [ centerX ] (text ("Total Athletes: " ++ String.fromInt (List.length model.athletes)))
                        , el [ alignRight ] (text ("Top Female: " ++ topAthlete Female model.athletes))
                        ]
                    , row [ width fill, padding 10 ]
                        [ el [ alignLeft ] (text ("Top Climber: " ++ topClimber model.athletes))
                        , el [ alignRight ] (text ("Top Faller: " ++ topFaller model.athletes))
                        ]
                    , row [ padding 10, width fill ]
                        [ Element.indexedTable [ alignTop, height fill ]
                            { data = model.athletes
                            , columns =
                                [ { header = el [ Font.bold ] (Element.text "Athletes")
                                  , width = fill
                                  , view =
                                        \i athlete ->
                                            el
                                                [ Element.spacing 5
                                                , Element.padding 2
                                                , if modBy 2 i == 0 then
                                                    Background.color (Element.rgb255 221 221 221)

                                                  else
                                                    Background.color (Element.rgb255 255 255 255)
                                                ]
                                                (Element.text
                                                    (athlete.family_name
                                                        ++ ", "
                                                        ++ athlete.given_name
                                                    )
                                                )
                                  }
                                , { header = el [ Font.bold, Font.center ] (Element.text "Weight Category")
                                  , width = fill
                                  , view =
                                        \i athlete ->
                                            el
                                                [ Element.spacing 5
                                                , Element.padding 2
                                                , Font.center
                                                , if modBy 2 i == 0 then
                                                    Background.color (Element.rgb255 221 221 221)

                                                  else
                                                    Background.color (Element.rgb255 255 255 255)
                                                ]
                                                (Element.text
                                                    athlete.weight_name
                                                )
                                  }
                                , { header = el [ Font.bold ] (Element.text "Position")
                                  , width = fill
                                  , view =
                                        \i athlete ->
                                            let
                                                change =
                                                    athlete.place_prev - athlete.place

                                                arrow =
                                                    if change > 0 then
                                                        " ⭧ "

                                                    else if change == 0 then
                                                        " ⭢"

                                                    else
                                                        " ⭨ "
                                            in
                                            el
                                                [ Element.spacing 5
                                                , Element.padding 2
                                                , if modBy 2 i == 0 then
                                                    Background.color (Element.rgb255 221 221 221)

                                                  else
                                                    Background.color (Element.rgb255 255 255 255)
                                                ]
                                                (Element.text
                                                    ("#"
                                                        ++ String.fromInt athlete.place
                                                        ++ " ("
                                                        ++ String.fromInt athlete.sum_points
                                                        ++ " points) "
                                                        ++ arrow
                                                        ++ (if change /= 0 then
                                                                String.fromInt change

                                                            else
                                                                ""
                                                           )
                                                    )
                                                )
                                  }
                                ]
                            }
                        ]
                    ]
                ]
            , row [ alignBottom, width fill, padding 10, Background.gradient { angle = 3.14, steps = [ Element.rgb255 67 69 122, Element.rgb255 54 51 93 ] } ]
                [ Element.link
                    [ Font.center
                    , alignLeft
                    , Font.family
                        [ Font.serif
                        ]
                    , Font.color (Element.rgb255 255 255 255)
                    ]
                    { label = Element.text "www.judowrl.com", url = "https://judowrl.com" }
                , Element.link
                    [ Font.center
                    , alignRight
                    , Font.family
                        [ Font.serif
                        ]
                    , Font.color (Element.rgb255 255 255 255)
                    ]
                    { label = Element.text "lancew/WRL_hacks", url = "https://github.com/lancew/WRL_hacks" }
                ]
            ]



-- If Landscape just use the same phone layout for now.


viewPhoneLandscape : Model -> Html Msg
viewPhoneLandscape model =
    viewPhonePortrait model


viewPhonePortrait : Model -> Html Msg
viewPhonePortrait model =
    Element.layout [ Font.size 64 ] <|
        column [ width fill ]
            [ row [ width fill ]
                [ column [ height fill, width (fillPortion 4) ]
                    [ Element.table
                        [ alignTop, height fill, padding 5 ]
                        { data = model.nations
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "")
                              , width = fill
                              , view =
                                    \nation ->
                                        Input.button [ padding 8, Border.width 2, centerX, centerY ]
                                            { onPress = Just (GetAthletes nation.ioc)
                                            , label =
                                                let
                                                    flag =
                                                        case Countries.fromCode nation.ioc of
                                                            Just nat ->
                                                                nat.flag

                                                            Nothing ->
                                                                ""
                                                in
                                                Element.text
                                                    (flag
                                                        ++ " "
                                                        ++ nation.ioc
                                                    )
                                            }
                              }
                            ]
                        }
                    ]
                , column [ width (fillPortion 10), alignTop, Font.size 40, padding 5 ]
                    [ row [ width fill ] [ el [ centerX ] (text "Top Male:") ]
                    , row [ width fill ] [ el [ centerX ] (text (topAthlete Male model.athletes)) ]
                    , row [ width fill ] [ el [ centerX ] (text "Top female") ]
                    , row [ width fill ] [ el [ centerX ] (text (topAthlete Female model.athletes)) ]
                    , row [ width fill ] [ el [ centerX ] (text "Top climber") ]
                    , row [ width fill ] [ el [ centerX ] (text (topClimber model.athletes)) ]
                    , row [ width fill ] [ el [ centerX ] (text "Total athletes") ]
                    , row [ width fill ] [ el [ centerX ] (text (String.fromInt (List.length model.athletes))) ]
                    , row [ width fill ] [ el [ centerX ] (text "Top faller") ]
                    , row [ width fill ] [ el [ centerX ] (text (topFaller model.athletes)) ]
                    , row [ width fill ] [ el [ centerX ] (text "---") ]
                    , row [ width fill ]
                        [ Element.indexedTable [ alignTop, height fill, width fill, Font.size 40 ]
                            { data = model.athletes
                            , columns =
                                [ { header = el [ Font.bold ] (Element.text "")
                                  , width = fill
                                  , view =
                                        \i athlete ->
                                            let
                                                change =
                                                    athlete.place_prev - athlete.place

                                                arrow =
                                                    if change > 0 then
                                                        " ⭧ "

                                                    else if change == 0 then
                                                        " ⭢"

                                                    else
                                                        " ⭨ "
                                            in
                                            el
                                                [ Element.spacing 1
                                                , Element.padding 1
                                                , if modBy 2 i == 0 then
                                                    Background.color (Element.rgb255 221 221 221)

                                                  else
                                                    Background.color (Element.rgb255 255 255 255)
                                                ]
                                                (Element.text
                                                    (athlete.family_name
                                                        ++ ", "
                                                        ++ athlete.given_name
                                                        ++ " #"
                                                        ++ String.fromInt athlete.place
                                                        ++ " "
                                                        ++ arrow
                                                    )
                                                )
                                  }
                                ]
                            }
                        ]
                    ]
                ]
            ]



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
