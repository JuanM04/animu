import 'package:flutter/material.dart';

class CastGuide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Guía')),
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Conectar en Windows'),
            subtitle: Text('Necesitás descargar e instalar el famoso reproductor VLC (Versión 3 o superior).\n\n' +
                'Una vez instalado e iniciado, andá a "Herramientas" y a "Preferencias".\n\n' +
                'En la opción de "Mostrar ajustes" abajo a la izquierda, seleccioná "Todo".\n\n' +
                'En la sección "Interfaz", "Interfaces principales", activá la opción "Web".\n\n' +
                'En el menú izquierdo desplegá las opciones de "Interfaces principales" y accedé a la opción "Lua".\n\n' +
                'Una vez allí pon una contraseña en "Lua HTTP".\n\n' +
                'Reiniciá VLC y permití el acceso en el mensaje del Firewall de Windows que te saldrá.\n\n' +
                '¡Listo! Ahora llená los campos en la opción Trasmitir (si no sabés la IP local de tu computadora, googleá cómo se obtiene) y conectate. Si sabés cómo reservar una IP en tu red, es recomendable que lo hagas.\n\n'),
          ),
          ListTile(
            title: Text('Conectar en Mac'),
            subtitle: Text(
                'Necesitás descargar e instalar el famoso reproductor VLC (Versión 3 o superior).\n\r' +
                    'Una vez instalado e iniciado, andá a "Preferencias".\n\n' +
                    'En el apartado de "Interfaz" bajá hasta "Interfaz web HTTP".\n\n' +
                    'Activala y poné una contraseña.\n\n' +
                    'Reiniciá VLC.\n\n' +
                    '¡Listo! Ahora llená los campos en la opción Trasmitir (si no sabés la IP local de tu computadora, googleá cómo se obtiene) y conectate. Si sabés cómo reservar una IP en tu red, es recomendable que lo hagas.\n\n'),
          ),
          ListTile(
              title: Text('Conectar en Linux/Rasperry Pi'),
              subtitle: Text('Abrí la línea de comandados y descagá VLC.\n`sudo apt-get vlc`\n\n' +
                  'Iniciá el servidor.\n```vlc --no-video-title-show --intf http --http-port PUERTO --http-password "CONTRASEÑA"```\n\n' +
                  'Opcionalmente podés correr el servidor automáticamente cuando inicia, corriendo\n```crontab -e```,\n y agregando\n```@reboot EL_MISMO_COMANDO_DE_ARRIBA &```\ny guardando el archivo.\n\n' +
                  '¡Listo! Ahora llená los campos en la opción Trasmitir (si no sabés la IP local de tu computadora, googleá cómo se obtiene) y conectate. Si sabés cómo reservar una IP en tu red, es recomendable que lo hagas.\n\n')),
        ],
      ),
    );
  }
}
