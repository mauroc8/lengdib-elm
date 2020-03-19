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


type Dibujo a
    = Simple a
    | Rotar (Dibujo a)
    | Espejar (Dibujo a)
    | Rot45 (Dibujo a)
    | Apilar Int Int (Dibujo a) (Dibujo a)
    | Juntar Int Int (Dibujo a) (Dibujo a)
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


rot45 : Dibujo a -> Dibujo a
rot45 =
    Rot45


{-| Acá aprovecho para cambiar la "API".
Estoy experimentando entre

    apilar ( 1, casa ) ( 2, jardin )


    -- Así era antes
    apilar 1 2 casa jardin

-}
apilar : ( Int, Dibujo a ) -> ( Int, Dibujo a ) -> Dibujo a
apilar ( x, a ) ( y, b ) =
    Apilar x y a b


{-| Poner dos dibujos lado a lado, donde cada uno ocupa una
proporción del total.
-}
juntar : ( Int, Dibujo a ) -> ( Int, Dibujo a ) -> Dibujo a
juntar ( x, a ) ( y, b ) =
    Juntar x y a b


{-| Aprovecho a cambiarle el nombre porque me parece más claro
-}
superponer : Dibujo a -> Dibujo a -> Dibujo a
superponer =
    Encimar


{-| Renderizar el dibujo en Html.
-}
aHtml : (a -> Html msg) -> Dibujo a -> Html msg
aHtml interprete dibujo =
    let
        fullWidth =
            [ Attributes.style "width" "300px"
            , Attributes.style "height" "300px"
            ]
    in
    case dibujo of
        Simple a ->
            Html.div
                fullWidth
                [ interprete a ]

        Rotar child ->
            Html.div
                [ Attributes.style "transform" "rotate(90deg) translate(300px, 300px)"
                ]
                [ aHtml interprete child ]

        Espejar child ->
            Html.div
                [ Attributes.style "transform" "scale(-1, 1)"
                ]
                [ aHtml interprete child ]

        Rot45 child ->
            Html.div [] [ aHtml interprete child ]

        Apilar a b childLeft childRight ->
            Html.div fullWidth
                [ Html.div
                    (apilarArriba a b)
                    [ aHtml interprete childLeft
                    ]
                , Html.div
                    (apilarAbajo a b)
                    [ aHtml interprete childRight
                    ]
                ]

        Juntar a b childLeft childRight ->
            Html.div fullWidth
                [ Html.div (juntarIzquierda a b)
                    [ aHtml interprete childLeft ]
                , Html.div (juntarDerecha a b)
                    [ aHtml interprete childRight ]
                ]

        Encimar childLeft childRight ->
            Html.div
                (fullWidth
                    ++ [ Attributes.style "position" "relative"
                       ]
                )
                [ Html.div encimarAttrs [ aHtml interprete childLeft ]
                , Html.div encimarAttrs [ aHtml interprete childRight ]
                ]



--- Ayudantes Html


juntarIzquierda : Int -> Int -> List (Attribute msg)
juntarIzquierda a b =
    let
        k =
            toFloat a / toFloat b
    in
    [ scaleXtranslateX k (-(1 - k) / 2) ]


apilarArriba : Int -> Int -> List (Attribute msg)
apilarArriba a b =
    let
        k =
            toFloat a / toFloat b
    in
    [ scaleYtranslateY k (-(1 - k) / 2) ]


juntarDerecha : Int -> Int -> List (Attribute msg)
juntarDerecha a b =
    let
        k =
            toFloat a / toFloat b
    in
    [ scaleXtranslateX k (k / 2) ]


apilarAbajo : Int -> Int -> List (Attribute msg)
apilarAbajo a b =
    let
        k =
            toFloat a / toFloat b
    in
    [ scaleYtranslateY k (k / 2) ]


encimarAttrs : List (Attribute msg)
encimarAttrs =
    [ Attributes.style "position" "absolute"
    , Attributes.style "left" "0"
    , Attributes.style "top" "0"
    , Attributes.style "right" "0"
    , Attributes.style "bottom" "0"
    ]


scaleXtranslateX : Float -> Float -> Attribute msg
scaleXtranslateX s t =
    [ "scale(" ++ String.fromFloat s ++ ", 1)"
    , "translate(" ++ aPorcentaje t ++ ", 0)"
    ]
        |> String.join " "
        |> Attributes.style "transform"


scaleYtranslateY : Float -> Float -> Attribute msg
scaleYtranslateY s t =
    [ "scale(1, " ++ String.fromFloat s ++ ")"
    , "translate(0, " ++ aPorcentaje t ++ ")"
    ]
        |> String.join " "
        |> Attributes.style "transform"


aPorcentaje : Float -> String
aPorcentaje x =
    round (x * 100)
        |> String.fromInt
        |> (\p -> p ++ "%")
