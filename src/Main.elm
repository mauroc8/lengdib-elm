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
    -- El `<|` es como el `$` en haskell
    Dibujo.aHtml Basicas.interprete <|
        apilar ( 1, simple Cuadrado ) ( 2, simple Circulo )
