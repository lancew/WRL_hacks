module Views exposing (view)

import Countries
import Element exposing (alignBottom, alignLeft, alignRight, alignTop, centerX, centerY, column, el, fill, fillPortion, height, padding, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font exposing (center)
import Element.Input as Input
import Helpers exposing (topAthlete, topClimber, topFaller)
import Html exposing (Html, button)
import Types exposing (Gender(..), Model, Msg(..))



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
                                                                "🥋"
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
                                                        " ↑ "

                                                    else if change == 0 then
                                                        " → "

                                                    else
                                                        " ↓ "
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
                [ column [ width (fillPortion 10), alignTop, Font.size 40, padding 5 ]
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
                                                        " ↑ "

                                                    else if change == 0 then
                                                        " → "

                                                    else
                                                        " ↓ "
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
                , column [ height fill, width (fillPortion 4) ]
                    [ Element.table
                        [ alignTop, height fill, padding 5 ]
                        { data = model.nations
                        , columns =
                            [ { header = el [ Font.bold ] (Element.text "Nation")
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
                                                                "🥋"
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
                ]
            ]
