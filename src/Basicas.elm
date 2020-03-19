module Basicas exposing (Basicas(..), interprete)

import Html exposing (Attribute, Html)
import Html.Attributes exposing (style)


type Basicas
    = Cuadrado
    | Circulo
    | Triangulo


interprete : ( Int, Int ) -> Basicas -> Html msg
interprete size basica =
    let
        ( width, height ) =
            size

        sizeAttrs =
            [ style "width" (String.fromInt width ++ "px")
            , style "height" (String.fromInt height ++ "px")
            ]
    in
    -- Esta es la única sintaxis para hacer pattern matching en elm.
    -- La indentación es importante (sino no compila).
    case basica of
        Cuadrado ->
            Html.div
                -- Los `::` son como el `:` en haskell, para construir listas.
                (style "background-color" "rgba(0, 255, 0, 0.8)"
                    :: sizeAttrs
                )
                []

        Circulo ->
            Html.div
                (style "border-radius" "50%"
                    :: style "background-color" "rgba(255, 0, 0, 0.8)"
                    :: sizeAttrs
                )
                []

        Triangulo ->
            let
                px x =
                    String.fromFloat x ++ "px"

                -- https://css-tricks.com/snippets/css/css-triangle/
                bottom =
                    toFloat width

                sides =
                    bottom / 2
            in
            Html.div
                (style "box-sizing" "border-box"
                    :: style "border-bottom" (px bottom ++ " solid rgba(0, 0, 255, 0.8)")
                    :: style "border-left" (px sides ++ " solid transparent")
                    :: style "border-right" (px sides ++ " solid transparent")
                    :: sizeAttrs
                )
                []



-- Fácilmente podríamos reemplazar el Html de una figura con una imágen cargada por el usuario ...
-- Sólo hay que respetar ponerle los "sizeAttrs" (width y height) correspondientes.
