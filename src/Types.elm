module Types exposing (Athlete, Gender(..), Model, Msg(..), Nation)

import Browser.Dom as Dom
import Element
import Http



-- MODEL


type alias Model =
    { nations : List Nation
    , nation : String
    , athletes : List Athlete
    , error : String
    , device : Element.Device
    , viewport : Maybe Dom.Viewport
    }


type Msg
    = GetAthletes String
    | FetchNations (Result Http.Error (List Nation))
    | FetchAthletes (Result Http.Error (List Athlete))
    | SetScreenSize Int Int
    | NoOp
    | ViewportResult Dom.Viewport



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
    , gender : Gender
    , given_name : String
    , place : Int
    , place_prev : Int
    , sum_points : Int
    , weight_name : String
    }
