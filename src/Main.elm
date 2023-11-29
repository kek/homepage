module Main exposing (..)

import Browser
import Html exposing (Html, div, h1, h2, li, p, text, ul)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Decoder, field, map2, string)
import List exposing (map)



-- MAIN


main : Program PerhapsFlags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- Elm code


type alias Flags =
    { apiUrl : String
    }


type alias PerhapsFlags =
    Json.Decode.Value


init : PerhapsFlags -> ( Model, Cmd Msg )
init flags =
    ( noContent, getDataFrom (getApiUrlFromFlags flags) )


getApiUrlFromFlags : PerhapsFlags -> String
getApiUrlFromFlags jsonEncodedFlags =
    case Json.Decode.decodeValue flagsDecoder jsonEncodedFlags of
        Ok decodedFlags ->
            decodedFlags.apiUrl

        Err _ ->
            "http://localhost:4000/things"


noContent : Model
noContent =
    { items = [], error = Nothing }


successContent : List Item -> Model
successContent value =
    { items = value, error = Nothing }


errorContent : List Item -> Http.Error -> Model
errorContent items _ =
    { items = items, error = Just "Something went wrong." }


getDataFrom : String -> Cmd Msg
getDataFrom apiUrl =
    Http.get
        { url = apiUrl
        , expect = Http.expectJson DataReceived (Json.Decode.list itemDecoder)
        }


itemDecoder : Decoder Item
itemDecoder =
    map2 Item
        (field "title" string)
        (field "description" string)


flagsDecoder : Decoder Flags
flagsDecoder =
    Json.Decode.map Flags
        (field "apiUrl" string)



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
    div []
        [ h1 [ class "text-blue-950 mt-10 flex items-center text-sm font-semibold leading-6" ] [ text "Welcome to the example app!" ]
        , ul [] (itemList model)
        ]


{-| Render list of posts.
-}
itemList : Model -> List (Html Msg)
itemList model =
    case model.error of
        Just error ->
            [ text error ]

        Nothing ->
            map viewItem model.items


viewItem : Item -> Html Msg
viewItem item =
    li []
        [ h2 [] [ text item.title ]
        , p [] [ text item.description ]
        ]
