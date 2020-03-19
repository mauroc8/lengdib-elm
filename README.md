# Lengdib-elm

Portando (lengdib)[https://gitlab.com/karen.p/lengdib] a elm.

## Correr servidor

Hace falta tener instalado [parcel](https://parceljs.org/getting_started.html).

Con este comando se inicia el servidor (y se instalan todas las dependencias que sean necesarias).

`parcel src/index.html`

Es probable que tengas que tener instalado [elm](https://guide.elm-lang.org/install/elm.html).

## Notas de conversión

### Sobre elm

En elm no existen los `typeclasses`, o sea que no se puede declarar algo como "mónada" o "functor aplicativo".
Sin embargo, sí se pueden declarar la función `bind`, que es lo que importa.

En elm la función `bind` se llama `andThen` y tiene los argumentos invertidos, para poder hacer _pipe_.

Le digo "hacer _pipes_" cuando se usa la función `|> : a -> (a -> b) -> b` para encadenar llamadas.

```elm
    -- Sin pipes
    List.filter (\x -> modBy 2 x == 0)
        (List.map ((*) 3) [1, 2, 3, 4, 5, 6])

    -- Con pipes
    [1, 2, 3, 4, 5, 6]
        |> List.map ((*) 3)
        |> List.filter (\x -> modBy 2 x == 0)
```

Elm tiene una manera muy particular de indentar el código,
pero la instalación viene con `elm format` que te formatea el código automáticamente.
Se recomienda configurar el editor para formatear al guardar ("Format on save").

Para aprender más de elm recomiendo la [guía oficial](https://guide.elm-lang.org/)
y la [documentación de los paquetes](https://package.elm-lang.org/), que son excelentes.
Tener cuidado al buscar en google! A veces sale la documentación de versiones anteriores.

### Dibujar

Por ahora, para probar un dibujo hay que escribirlo en el código y compilar de nuevo.

```elm
    -- src/Main.elm
    main =
        Dibujo.toHtml Basicas.interprete <|
            miDibujo

    miDibujo : Dibujo
```

La conversión a Html es simplista. Se puede convertir a Svg o pintar en un `<canvas>` en vez de usar Html.

## Licencia

Se usa GNU-GPL igual que el [repositorio original](https://gitlab.com/karen.p/lengdib).
