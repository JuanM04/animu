import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

final shareMessages = <String>[
  '¿También sos otaku?',
  'Omae wa mou shindeiru. ¡¿NANI?!',
  'No sabés, encontré el Santo Grial.',
  'Te diría que socialices, pero tengo algo mejor...',
  'UHH, ¡Qué olor a otaku! Mirá esto y bañate, por Dios.',
  'Algún día entenderemos el final de Evangelion, pero mientras tanto...',
  'A al distancia parece la app de RedTube.',
  'Dejá lo que estés haciendo en este mismo instante.',
  '¿Listo para entender mis JoJo-referencias?',
  'Google dice que es un virus... porque te infecta y no parás de ver anime.',
];

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset('images/Name.png'),
        ),
        SizedBox(height: 30),
        Text(
          'Animú es una aplicación para ver anime fácilmente. Funciona (de manera no oficial) con los servidores de AnimeFLV.net.',
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(
                  (shareMessages..shuffle()).first +
                      '\nDescargá Animú en https://animu.juanm04.com',
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () async {
                showAboutDialog(
                  context: context,
                  applicationVersion:
                      'v' + (await PackageInfo.fromPlatform()).version,
                  applicationIcon: Image.asset(
                    'images/Icon.png',
                    width: 64,
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          'Hecho con ❤️ por JuanM04',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
