module State exposing (..)

import AnimationFrame
import Array
import Mouse
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
      , mouse = Nothing
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

        MouseMoved position ->
            ( { model | mouse = Just position }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs Tick
        , Mouse.moves MouseMoved
        ]
