module Main exposing (main)

import Basicas exposing (Basicas(..))
import Dibujo exposing (Dibujo, apilar, espejar, juntar, rot45, rotar, simple, superponer)
import Html exposing (Html)



-- Importamos Basicas exponiendo `(Basicas(..))`.
-- Los dos puntitos significan que además de el tipo `Basicas.Basicas`
-- vamos a importar todos los constructores, o sea que ahora podemos decir
-- `Circulo` en vez de `Basicas.Circulo`.


main : Html msg
main =
    Dibujo.aHtml ( 400, 400 ) Basicas.interprete dibujo


dibujo : Dibujo Basicas
dibujo =
    apilar 0.33
        (juntar 0.5 (simple Cuadrado) (simple Circulo))
        (cuadrantesRecursivo 3 intToBasicas)


cuadrantesRecursivo : Int -> (Int -> Basicas) -> Dibujo Basicas
cuadrantesRecursivo nivel figura =
    if nivel <= 0 then
        -- El <| es como el $ en haskell
        simple <| figura 0

    else
        let
            alternada =
                -- El operador `<<` es como `.` en haskell,
                -- hace composición de funciones.
                figura << (+) 1
        in
        apilar 0.5
            (juntar 0.5
                (cuadrantesRecursivo (nivel - 1) alternada)
                (cuadrantesRecursivo (nivel - 1) figura)
            )
            (juntar 0.5
                (cuadrantesRecursivo (nivel - 1) figura)
                (cuadrantesRecursivo (nivel - 1) alternada)
            )


intToBasicas : Int -> Basicas
intToBasicas i =
    if modBy 3 i == 0 then
        Circulo

    else if modBy 3 i == 1 then
        Cuadrado

    else
        Triangulo
