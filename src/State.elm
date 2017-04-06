module State exposing (..)

import AnimationFrame
import Array
import Types exposing (..)


init : ( Model, Cmd Msg )
init =
    ( { boids =
            Array.fromList
                [ { position = { x = 50, y = 50, z = 0 }
                  , velocity = { x = 5, y = 3, z = 0 }
                  }
                , { position = { x = 1, y = 2, z = 2 }
                  , velocity = { x = -5, y = 3, z = 0 }
                  }
                ]
      , delta = 0.0
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | delta = time }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs Tick
