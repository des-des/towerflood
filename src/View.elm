module View exposing (..)

import Array
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    Html.div []
        [ Svg.svg
            [ width "100vw"
            , height "80vh"
            , viewBox "-500 -500 1000 1000"
            ]
            [ g []
                (model.boids
                    |> Array.toList
                    |> List.map boidView
                )
            ]
        ]


boidView : Boid -> Svg msg
boidView boid =
    circle
        [ cx <| toString boid.position.x
        , cy <| toString boid.position.y
        , r "5px"
        ]
        []
