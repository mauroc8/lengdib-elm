module Basicas exposing (Basicas(..), interprete)

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes


type Basicas
    = Cuadrado
    | Circulo


interprete : Basicas -> Html msg
interprete basica =
    -- Esta es la única sintaxis para hacer pattern matching en elm.
    -- La indentación es importante (sino no compila).
    case basica of
        Cuadrado ->
            Html.div
                attrs
                []

        Circulo ->
            Html.div
                (Attributes.style "border-radius" "50%"
                    -- Los `::` son como el `:` en haskell, para construir listas.
                    :: attrs
                )
                []


attrs : List (Attribute msg)
attrs =
    [ Attributes.style "width" "100%"
    , Attributes.style "height" "100%"
    , Attributes.style "background-color" "rgba(0, 0, 0, 0.8)"
    ]
