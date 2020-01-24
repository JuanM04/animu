![Banner](images/Banner.png)  

![Version](https://img.shields.io/github/v/release/JuanM04/animu?style=flat-square)
![License](https://img.shields.io/github/license/JuanM04/animu?style=flat-square)
![Flutter](https://img.shields.io/static/v1?label=Flutter&message=v1.12&logo=flutter&color=02569B&style=flat-square)
![ZEIT Now](https://img.shields.io/static/v1?label=ZEIT%20Now&message=v2&logo=zeit&color=000000&style=flat-square)

## ¿Qué es Animú?

Animú es una app para ver anime sin complicaciones. Funciona con los servidores de AnimeFLV, por lo que cuenta con una amplica gama de animes.

### ¿Cómo funciona?

Animú consta de la app (hecha en Flutter), [AnimeFLV GraphQL](https://github.com/JuanM04/animeflv-graphql) y una función en ZEIT Now.

Todos los datos son guardados con [HiveDB](https://github.com/hivedb/hive). Para el modo Transmitir, se usa la API proveida por VLC 3+. Más información [aquí](https://wiki.videolan.org/VLC_HTTP_requests/).

### ¿Por qué está todo en inglés?

Tengo problemas, no me peguen.

## Setup

1. Agregar `android/app/google-services.json` de Firebase. Firebase debe tener las aplicaciones `com.juanm04.animu` y `com.juanm04.animu.dev` con las llaves de desarrollo SHA
2. Agregar el `google-services.json` a modo de secreto al repositorio de GitHub (`base64 android/app/google-services.json`).
3. Ejecturar `flutter pub get`.

## To-do

- Hacer tests