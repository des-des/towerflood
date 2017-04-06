module Types exposing (..)

import Array exposing (Array)
import Time exposing (Time)


type Msg
    = Tick Time


type alias Vector =
    { x : Int
    , y : Int
    , z : Int
    }


type alias Boid =
    { position : Vector
    , velocity : Vector
    }


type alias Model =
    { boids : Array Boid
    , delta : Time
    }
