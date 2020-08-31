module Main exposing (main)

import Browser as Browser
import Browser.Events as Events
import Element
import Helpers exposing (..)
import Http
import Types exposing (..)
import Views exposing (..)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
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
      , viewport = Nothing
      }
    , getNationsFromAPI
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ Events.onResize (\values -> SetScreenSize values) ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetAthletes nationIOC ->
            ( { model | nation = nationIOC }, getAthletesFromAPI nationIOC )

        FetchNations result ->
            case result of
                Ok nations ->
                    ( { model | nations = nations, error = "" }, getViewport )

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

        ViewportResult viewP ->
            let
                classifiedDevice =
                    Element.classifyDevice
                        { width = round viewP.viewport.width
                        , height = round viewP.viewport.height
                        }
            in
            ( { model | viewport = Just viewP, device = classifiedDevice }, Cmd.none )
