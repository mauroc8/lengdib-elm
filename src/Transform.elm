module Transform exposing
    ( Apilado(..)
    , Juntado(..)
    , Transform
    , apilar
    , espejar
    , identidad
    , juntar
    , rot45
    , rotar
    , toAttribute
    )

import Html
import Html.Attributes as Attributes


{-| El objetivo de `Transform` es representar una matriz
para poder usar como (transformación en Css)[1].

[1]: https://developer.mozilla.org/en-US/docs/Web/CSS/transform-function/matrix

En particular, tenemos la función `toAttribute` que nos deja aplicar la transformación
a un elemento Html.

    main =
        Html.div
            [ Transform.toAttribute Transform.rot45 ]
            [ Html.text "Hola mundo" ]

-}
type alias Transform =
    { scaleX : Float
    , scaleY : Float
    , skewX : Float
    , skewY : Float
    , translateX : Float
    , translateY : Float
    }


{-| La transformación `identidad` no modifica el componente.
-}
identidad : Transform
identidad =
    { scaleX = 1
    , scaleY = 1
    , skewX = 0
    , skewY = 0
    , translateX = 0
    , translateY = 0
    }



{-

   Para hacer `rotar` usé las funciones de esta página

   https://developer.mozilla.org/en-US/docs/Web/CSS/transform-function/rotate

   Pero cambiando el orden de los atributos según el orden:

   [ scaleX, skewY, skewX, scaleY, ... ]

   Ver [1] para consultar este orden.

   [1]: https://developer.mozilla.org/en-US/docs/Web/CSS/transform-function/matrix

-}


{-| Rota 90 grados en sentido antihorario.
-}
rotar : Transform
rotar =
    let
        a =
            negate <| pi / 2
    in
    { scaleX = cos a
    , scaleY = cos a
    , skewX = negate (sin a)
    , skewY = sin a
    , translateX = 0
    , translateY = 0
    }


espejar : Transform
espejar =
    { scaleX = -1
    , scaleY = 1
    , skewX = 0
    , skewY = 0
    , translateX = 0
    , translateY = 0
    }


rot45 : Transform
rot45 =
    { scaleX = 0.5
    , scaleY = 0.5
    , skewX = 0.5
    , skewY = -0.5
    , translateX = 0
    , translateY = -0.5
    }


{-| Un `Apilado` puede ser `Arriba` o `Abajo`
-}
type Apilado
    = Arriba
    | Abajo


{-| `apilar` toma una dirección de apilado, que puede ser `Arriba` o `Abajo`,
y un `Float` que representa de 0 a 1 el lugar donde se hace la división entre arriba y abajo.
-}
apilar : Apilado -> Float -> Transform
apilar apilado k =
    let
        x =
            clamp 0 1 k
    in
    case apilado of
        Arriba ->
            { scaleX = 1
            , scaleY = x
            , skewX = 0
            , skewY = 0
            , translateX = 0
            , translateY = (x - 1) / 2
            }

        Abajo ->
            { scaleX = 1
            , scaleY = 1 - x
            , skewX = 0
            , skewY = 0
            , translateX = 0
            , translateY = x / 2
            }


{-| Un `Juntado` puede ser `Izquierda` o `Derecha`
-}
type Juntado
    = Izquierda
    | Derecha


{-| Una transformación que coloca dos sub-imágenes lado a lado, escaladas para completar el total.

Juntar toma un juntado --que puede ser `Izquierda` o `Derecha`-- y un `Float`
que representa de 0 a 1 el lugar de la división.

-}
juntar : Juntado -> Float -> Transform
juntar juntado k =
    let
        x =
            clamp 0 1 k
    in
    case juntado of
        Izquierda ->
            { scaleX = x
            , scaleY = 1
            , skewX = 0
            , skewY = 0
            , translateX = (x - 1) / 2
            , translateY = 0
            }

        Derecha ->
            { scaleX = 1 - x
            , scaleY = 1
            , skewX = 0
            , skewY = 0
            , translateX = x / 2
            , translateY = 0
            }


toAttribute : ( Int, Int ) -> Transform -> Html.Attribute msg
toAttribute ( width, height ) { scaleX, scaleY, skewX, skewY, translateX, translateY } =
    Attributes.style "transform" <|
        "matrix("
            -- En https://developer.mozilla.org/en-US/docs/Web/CSS/transform-function/matrix
            -- hay una referencia del orden en que tienen que estar los parámetros.
            ++ String.fromFloat scaleX
            ++ ","
            ++ String.fromFloat skewY
            ++ ","
            ++ String.fromFloat skewX
            ++ ","
            ++ String.fromFloat scaleY
            ++ ","
            -- Las traslaciones se realizan en *píxeles*, pero nosotros las guardamos como porcentaje.
            -- Acá hacemos la conversión porcentaje -> px.
            ++ String.fromFloat (translateX * toFloat width)
            ++ ","
            ++ String.fromFloat (translateY * toFloat height)
            ++ ")"
