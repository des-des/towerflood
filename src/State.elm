module State exposing (..)

import AnimationFrame
import Array exposing (Array)
import Mouse
import Random
import Random exposing (Generator)
import Time exposing (Time)
import Types exposing (..)


generateVector : Float -> Float -> Generator Vector
generateVector from to =
    Random.map3 Vector
        (Random.float from to)
        (Random.float from to)
        (Random.float from to)


generateBoid : Generator Boid
generateBoid =
    Random.map2 Boid
        (generateVector -100 100)
        (generateVector -2.5 2.5)


init : ( Model, Cmd Msg )
init =
    ( { boids = Array.empty
      , delta = 0.0
      , mouse = Nothing
      }
    , Random.generate SetBoids (Random.list 50 generateBoid)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetBoids boids ->
            ( { model | boids = Array.fromList boids }
            , Cmd.none
            )

        Tick time ->
            ( { model
                | delta = time
                , boids = updateBoids time model.boids
              }
            , Cmd.none
            )

        MouseMoved position ->
            ( { model | mouse = Just position }
            , Cmd.none
            )


updateBoids : Time -> Array Boid -> Array Boid
updateBoids time boids =
    Array.map (updateBoid time) boids


updateBoid : Time -> Boid -> Boid
updateBoid time boid =
    { boid
        | position =
            add boid.position
                (scale (1 + (time / 10000000)) boid.velocity)
    }


add : Vector -> Vector -> Vector
add a b =
    { x = a.x + b.x
    , y = a.y + b.y
    , z = a.z + b.z
    }


scale : Float -> Vector -> Vector
scale c a =
    { x = a.x * c
    , y = a.y * c
    , z = a.z * c
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Tick
        , Mouse.moves MouseMoved
        ]
