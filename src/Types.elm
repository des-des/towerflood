module Types exposing (..)

import Array exposing (Array)
import Mouse
import Time exposing (Time)


type Msg
    = Tick Time
    | MouseMoved Mouse.Position
    | SetBoids (List Boid)


type alias Vector =
    { x : Float
    , y : Float
    , z : Float
    }


nullVector : Vector
nullVector =
    Vector 0 0 0


type alias Boid =
    { position : Vector
    , velocity : Vector
    }


type alias Model =
    { boids : Array Boid
    , delta : Time
    , mouse : Maybe Mouse.Position
    }
