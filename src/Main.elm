module Main exposing (..)

import Browser
import Html exposing (Html, div, h2, p, text)
import Http
import Json.Decode exposing (Decoder, field, map2, string)
import List exposing (map)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( noContent, getData )


noContent : Model
noContent =
    { items = [], error = Nothing }


successContent : List Item -> Model
successContent value =
    { items = value, error = Nothing }


errorContent : List Item -> Http.Error -> Model
errorContent items _ =
    { items = items, error = Just "Something went wrong." }


getData : Cmd Msg
getData =
    Http.get
        { url = "http://localhost:4000/things"
        , expect = Http.expectJson DataReceived (Json.Decode.list itemDecoder)
        }


itemDecoder : Decoder Item
itemDecoder =
    map2 Item
        (field "title" string)
        (field "description" string)



-- MODEL


type alias Item =
    { title : String
    , description : String
    }


type alias Model =
    { items : List Item
    , error : Maybe String
    }



-- UPDATE


type Msg
    = DataReceived (Result Http.Error (List Item))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DataReceived (Ok value) ->
            ( successContent value, Cmd.none )

        DataReceived (Err error) ->
            ( errorContent model.items error, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    case model.error of
        Just error ->
            div [] [ text error ]

        Nothing ->
            div [] (map viewItem model.items)


viewItem : Item -> Html Msg
viewItem item =
    div [] [ h2 [] [ text item.title ], p [] [ text item.description ] ]
