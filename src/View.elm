module View exposing (..)

import Array
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Types exposing (..)


root : Model -> Html Msg
root model =
    Html.div []
        [ Html.div []
            [ Html.code []
                [ Html.text <| toString model ]
            ]
        , Svg.svg
            [ width "100vw"
            , height "80vh"
            , viewBox "-100 -100 200 200"
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
