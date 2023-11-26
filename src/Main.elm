module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--

import Browser
import Html exposing (Html, div, p, text)
import Http



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( [], Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Item =
    { name : String
    , description : String
    }


type alias Model =
    List Item



-- UPDATE


type Msg
    = SendHttpRequest
    | DataReceived (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        _ ->
            ( [], Cmd.none )



-- VIEW


view : Model -> Html Msg
view _ =
    div []
        [ p [] [ text "Hello, World!" ] ]
