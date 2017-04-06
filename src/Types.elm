module Types exposing (..)

import Array exposing (Array)
import Mouse
import Time exposing (Time)


type Msg
    = Tick Time
    | MouseMoved Mouse.Position


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
    , mouse : Maybe Mouse.Position
    }
