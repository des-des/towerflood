module State exposing (..)

import AnimationFrame
import Array exposing (Array)
import Dict exposing (Dict)
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
        (generateVector -200 200)
        (generateVector -2.5 2.5)


gridSize : Int
gridSize =
    300


flockInfluence : Float
flockInfluence =
    3


init : ( Model, Cmd Msg )
init =
    ( { boids = Array.empty
      , delta = 0.0
      , mouse = Nothing
      }
    , Random.generate SetBoids (Random.list 100 generateBoid)
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
    let
        averagesGrid =
            Array.foldl addGridPosition Dict.empty boids
    in
        Array.map (updateBoid averagesGrid time) boids


addGridPosition :
    Boid
    -> Dict ( Int, Int, Int ) Vector
    -> Dict ( Int, Int, Int ) Vector
addGridPosition boid averages =
    Dict.update (gridPosition boid.position)
        (\currentAverage ->
            case currentAverage of
                Nothing ->
                    Just <| boid.velocity

                Just avg ->
                    Just <| add boid.velocity avg
        )
        averages


gridPosition : Vector -> ( Int, Int, Int )
gridPosition { x, y, z } =
    ( round x // gridSize
    , round y // gridSize
    , round z // gridSize
    )


updateBoid :
    Dict ( Int, Int, Int ) Vector
    -> Time
    -> Boid
    -> Boid
updateBoid averagesGrid time boid =
    let
        gridAverage =
            Dict.get (gridPosition boid.position) averagesGrid

        gridInfluence =
            gridAverage
                |> Maybe.withDefault nullVector
                |> normalise
                |> scale flockInfluence
    in
        { boid
            | position =
                boid.velocity
                    |> add boid.position
                    |> scale (1 + (time / 10000000))
                    |> add gridInfluence
        }


normalise : Vector -> Vector
normalise { x, y, z } =
    let
        hypo =
            sqrt ((x * x) + (y * y) + (z * z))
    in
        { x = x / hypo
        , y = y / hypo
        , z = z / hypo
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
