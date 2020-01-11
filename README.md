![Banner](images/Banner.png)  
![Version](https://img.shields.io/github/v/release/JuanM04/animu?style=flat-square)
![License](https://img.shields.io/github/license/JuanM04/animu?style=flat-square)
![Flutter](https://img.shields.io/static/v1?label=Flutter&message=v1.12&logo=flutter&color=02569B&style=flat-square)
![ZEIT Now](https://img.shields.io/static/v1?label=ZEIT%20Now&message=v2&logo=zeit&color=000000&style=flat-square)

## ¿Qué es Animú?

Animú es una app para ver anime sin complicaciones. Funciona con los servidores de AnimeFLV, por lo que cuenta con una amplica gama de animes.

### ¿Cómo funciona?

Animú consta de la app (hecha en Flutter) y un servidor en ZEIT Now.

Este último sirve para saltarse la seguridad de Cloudflare al momento de pedirle información a AnimeFLV. Esto se hace porque Animú usa Web Scraping, que básicamente es descargar el HTML y sacar el contenido de ahí (en vez de pedirlo a una API). Usa `web/api/get-cloudflare-id.ts` solamente para "fingir un PC real" y luego sigue haciendo peticiones desde la app. La página web está en `web/`.

Para el modo Transmitir, se usa la API proveida por VLC 3+. Más información [aquí](https://wiki.videolan.org/VLC_HTTP_requests/).

### ¿Por qué está todo en inglés?

Tengo problemas, no me peguen.

## To-do

- Animaciones
- Vincular animes guardados con Google
- Hacer tests