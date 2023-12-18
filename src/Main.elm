module Main exposing (..)

import Browser
import Html exposing (Html, a, article, div, h1, h2, li, p, text, ul)
import Html.Attributes as Attr exposing (class)
import Http
import Json.Decode exposing (Decoder, field, map2, string)
import List exposing (map)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Parser exposing (Problem)
import Parser.Advanced exposing (DeadEnd)



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
    div [ class "container mx-auto max-w-xl" ] (itemList model)


{-| Render list of posts.
-}
itemList : Model -> List (Html Msg)
itemList model =
    case model.error of
        Just error ->
            [ text error ]

        Nothing ->
            map viewItem model.items


deadEndsToString : List (DeadEnd String Problem) -> String
deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.Parser.deadEndToString
        |> String.join "\n"


render : Markdown.Renderer.Renderer view -> String -> Result String (List view)
render renderer markdown =
    markdown
        |> Markdown.Parser.parse
        |> Result.mapError deadEndsToString
        |> Result.andThen (\ast -> Markdown.Renderer.render renderer ast)


viewItem : Item -> Html Msg
viewItem item =
    article []
        (case render articleRenderer item.description of
            Ok html ->
                html

            Err error ->
                [ text error ]
        )


articleRenderer : Markdown.Renderer.Renderer (Html msg)
articleRenderer =
    { heading =
        \{ level, children } ->
            case level of
                Block.H1 ->
                    Html.h3 [ class "pt-8 pb-2 px-4 font-bold text-2xl" ] children

                Block.H2 ->
                    Html.h4 [ class "pt-4 pb-2 px-4 font-bold text-xl" ] children

                Block.H3 ->
                    Html.h5 [] children

                Block.H4 ->
                    Html.h6 [] children

                Block.H5 ->
                    Html.h6 [] children

                Block.H6 ->
                    Html.h6 [] children
    , paragraph = Html.p [ class "py-2 px-4 font-serif" ]
    , hardLineBreak = Html.br [] []
    , blockQuote = Html.blockquote []
    , strong =
        \children -> Html.strong [] children
    , emphasis =
        \children -> Html.em [] children
    , strikethrough =
        \children -> Html.del [] children
    , codeSpan =
        \content -> Html.code [] [ Html.text content ]
    , link =
        \link content ->
            case link.title of
                Just title ->
                    Html.a
                        [ Attr.href link.destination
                        , Attr.title title
                        ]
                        content

                Nothing ->
                    Html.a [ Attr.href link.destination ] content
    , image =
        \imageInfo ->
            case imageInfo.title of
                Just title ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        , Attr.title title
                        ]
                        []

                Nothing ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        ]
                        []
    , text =
        Html.text
    , unorderedList =
        \items ->
            Html.ul [ class "px-10" ]
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Block.ListItem task children ->
                                    let
                                        checkbox : Html msg
                                        checkbox =
                                            case task of
                                                Block.NoTask ->
                                                    Html.text ""

                                                Block.IncompleteTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked False
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []

                                                Block.CompletedTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked True
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    Html.li [ class "list-disc font-serif" ] (checkbox :: children)
                        )
                )
    , orderedList =
        \startingIndex items ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex ]

                    _ ->
                        []
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li []
                                itemBlocks
                        )
                )
    , html = Markdown.Html.oneOf []
    , codeBlock =
        \{ body, language } ->
            let
                classes : List (Html.Attribute msg)
                classes =
                    -- Only the first word is used in the class
                    case Maybe.map String.words language of
                        Just (actualLanguage :: _) ->
                            [ Attr.class <| "language-" ++ actualLanguage ]

                        _ ->
                            []
            in
            Html.pre []
                [ Html.code classes
                    [ Html.text body
                    ]
                ]
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs : List (Html.Attribute msg)
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th attrs
    , tableCell =
        \maybeAlignment ->
            let
                attrs : List (Html.Attribute msg)
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.td attrs
    }
