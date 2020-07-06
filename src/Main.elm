module Main exposing (main)

{--}
--}

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
    }


init _ =
    ( { nations = []
      , athletes = [ "Loading Athletes..." ]
      }
    , Cmd.none
    )



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = GetNations
    | GetAthletes
    | FetchNations (Result Http.Error (List Nation))


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
                    ( { model | nations = [] }, Cmd.none )



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
            , row [ padding 5, alignTop, height fill, width fill, spacing 5 ]
                [ column [ padding 5, height fill, width (fillPortion 1), Border.width 1, Border.rounded 5 ]
                    [ Input.button [ Border.width 5, Border.rounded 5, padding 5 ]
                        { label = text "Get Nations"
                        , onPress = Just GetNations
                        }
                    , Element.table
                        [ alignTop, height fill, padding 5 ]
                        { data = model.nations
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Nations")
                              , width = fill
                              , view =
                                    \nation ->
                                        el [] (Element.text nation.name)
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



{--

module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text, ul, li, button, span)
import Html.Events exposing (onClick)
import Json.Decode
import Http


type alias Post =
    {id_country: String, name: String, ioc: String }

type alias Model = 
    { posts: List Post, uiState: UiState, error: Maybe String }


initialModel : Model
initialModel =
    { posts = [], uiState = Init,  error = Nothing }

init: (Model, Cmd Msg)
init =
    (initialModel, Cmd.none)

type UiState
    = Init
    | Loading
    | Success
    | Failure


type Msg
    = InitFetchPosts
    | FetchPosts (Result Http.Error (List Post))


fetchPosts: Cmd Msg
fetchPosts =
        Http.get
            { url = "https://data.judobase.org/api/get_json?params[action]=country.get_list"
            , expect = Http.expectJson FetchPosts postCollectionDecoder 
            }


postDecoder : Json.Decode.Decoder Post
postDecoder =
    Json.Decode.map3 Post
        (Json.Decode.field "id_country" Json.Decode.string)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "ioc" Json.Decode.string)


postCollectionDecoder : Json.Decode.Decoder (List Post)
postCollectionDecoder =
    Json.Decode.map identity
        (Json.Decode.list postDecoder)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
         InitFetchPosts ->
            ( { model | uiState = Loading }, fetchPosts )

         FetchPosts result ->
            case result of
                Ok posts ->
                    ( { model | uiState = Success, posts = posts }, Cmd.none )

                Err _ ->
                    ( { model | uiState = Failure, error = Just "Error" }, Cmd.none )

renderItem: Post -> Html Msg
renderItem post =
    li [] [text post.name]
    
renderData: Model -> Html Msg
renderData model =
    case model.uiState of
        Init ->
            span [] []
        Loading ->
            span [] [text "Loading..."]
            
        Success -> 
          ul [] (List.map (\post -> renderItem post) model.posts)
          
        Failure ->
            case model.error of 
                Just error -> 
                    span [] [text error]

                Nothing ->
                    span [] []

view : Model -> Html Msg
view model =
    div []
        [ button [onClick InitFetchPosts] [text "Fetch Posts"]
        , renderData model
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }


--}
