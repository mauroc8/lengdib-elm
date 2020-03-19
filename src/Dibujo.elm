module Dibujo exposing
    ( Dibujo
    , aHtml
    , apilar
    , espejar
    , juntar
    , rot45
    , rotar
    , simple
    , superponer
    )

import Html exposing (Attribute, Html)
import Html.Attributes as Attributes
import Transform


type Dibujo a
    = Simple a
    | Rotar (Dibujo a)
    | Espejar (Dibujo a)
    | Rot45 (Dibujo a)
      -- NOTA: Cambié cómo representamos internamente el Apilar.
      -- Antes era `Apilar Int Int ...`. Ver comentario en la función `apilar`.
    | Apilar Float (Dibujo a) (Dibujo a)
    | Juntar Float (Dibujo a) (Dibujo a)
    | Encimar (Dibujo a) (Dibujo a)



-- A continuación se hacen "alias" de todos los constructores.
-- Esto sirve para hacer que el tipo sea *opaco*. Significa que no
-- se puede hacer pattern-matching sobre este tipo afuera de este módulo
-- (porque los constructores no se exportan).
-- No sé si conviene hacerlo opaco o no, estoy probando.


{-| Un dibujo simple
-}
simple : a -> Dibujo a
simple =
    Simple


{-| Un dibujo rotado 90 grados en sentido horario
-}
rotar : Dibujo a -> Dibujo a
rotar =
    Rotar


{-| Un dibujo espejado horizontalmente
-}
espejar : Dibujo a -> Dibujo a
espejar =
    Espejar


{-| Un dibujo rotado 45 grados y escalado de modo que la esquina superior izquierda permanezca fija,
pero la esquina inferior derecha pase a estar en la esquina superior derecha del marco.
-}
rot45 : Dibujo a -> Dibujo a
rot45 =
    Rot45


{-| Apila dos imágenes. La línea que las divide estará a un porcentaje del
espacio disponible, representado como un Float entre 0 y 1.

NOTA: Acá podríamos decidir por una API para apilar. Otras alternativas que probé son:

    -- original
    apilar : Int -> Int -> Dibujo a -> Dibujo a -> Dibujo a
    -- variante
    apilar : ( Int, Dibujo a ) -> ( Int, Dibujo a ) -> Dibujo a

Etc. Estoy probando con 1 sólo número.

-}
apilar : Float -> Dibujo a -> Dibujo a -> Dibujo a
apilar k a b =
    Apilar k a b


{-| Poner dos dibujos lado a lado. La línea que las divide estará a un porcentaje del
espacio disponible, representado como un Float entre 0 y 1.
-}
juntar : Float -> Dibujo a -> Dibujo a -> Dibujo a
juntar k a b =
    Juntar k a b


{-| Aprovecho a cambiarle el nombre porque me parece más claro
-}
superponer : Dibujo a -> Dibujo a -> Dibujo a
superponer =
    Encimar


{-| Renderizar el dibujo en Html.
-}
aHtml : ( Int, Int ) -> (( Int, Int ) -> a -> Html msg) -> Dibujo a -> Html msg
aHtml size interprete dibujo =
    let
        ( width, height ) =
            size

        sizeAttrs =
            [ Attributes.style "width" (String.fromInt width ++ "px")
            , Attributes.style "height" (String.fromInt height ++ "px")
            ]

        position =
            Attributes.style "position"

        -- para debuguear
        tag =
            Attributes.class
    in
    case dibujo of
        Simple a ->
            Html.div
                (tag "simple"
                    :: sizeAttrs
                )
                [ interprete size a ]

        Rotar child ->
            Html.div
                (Transform.toAttribute size Transform.rotar
                    :: tag "rotar"
                    :: sizeAttrs
                )
                [ aHtml size interprete child ]

        Espejar child ->
            Html.div
                (Transform.toAttribute size Transform.espejar
                    :: tag "espejar"
                    :: sizeAttrs
                )
                [ aHtml size interprete child ]

        Rot45 child ->
            Html.div
                (Transform.toAttribute size Transform.rot45
                    :: tag "rot45"
                    :: sizeAttrs
                )
                [ aHtml size interprete child ]

        Apilar k childLeft childRight ->
            Html.div
                (position "relative"
                    :: tag "apilar"
                    :: sizeAttrs
                )
                [ Html.div
                    (Transform.toAttribute size
                        (Transform.apilar Transform.Arriba k)
                        :: position "absolute"
                        :: tag "arriba"
                        :: sizeAttrs
                    )
                    [ aHtml size interprete childLeft ]
                , Html.div
                    (Transform.toAttribute size
                        (Transform.apilar Transform.Abajo k)
                        :: position "absolute"
                        :: tag "abajo"
                        :: sizeAttrs
                    )
                    [ aHtml size interprete childRight ]
                ]

        Juntar k childLeft childRight ->
            Html.div
                (position "relative"
                    :: tag "juntar"
                    :: sizeAttrs
                )
                [ Html.div
                    (Transform.toAttribute size
                        (Transform.juntar Transform.Izquierda k)
                        :: position "absolute"
                        :: tag "izquierda"
                        :: sizeAttrs
                    )
                    [ aHtml size interprete childLeft ]
                , Html.div
                    (Transform.toAttribute size
                        (Transform.juntar Transform.Derecha k)
                        :: position "absolute"
                        :: tag "derecha"
                        :: sizeAttrs
                    )
                    [ aHtml size interprete childRight ]
                ]

        Encimar childLeft childRight ->
            Html.div
                (position "relative"
                    :: tag "encimar"
                    :: sizeAttrs
                )
                [ Html.div
                    (position "absolute"
                        :: tag "detras"
                        :: sizeAttrs
                    )
                    [ aHtml size interprete childLeft ]
                , Html.div
                    (position "absolute"
                        :: tag "delante"
                        :: sizeAttrs
                    )
                    [ aHtml size interprete childRight ]
                ]
