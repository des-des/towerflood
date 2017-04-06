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
            [ width "800px"
            , height "600px"
            , viewBox "-400 -300 800 600"
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
        , r "3px"
        , fill "darkgoldenrod"
        ]
        []
