import 'package:animu/widgets/dialog_button.dart';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:pub_semver/pub_semver.dart';

class Updater extends StatefulWidget {
  final Version currentVersion;
  final Version latestVersion;
  final String downloadURL;
  Updater({
    Key key,
    this.currentVersion,
    this.latestVersion,
    this.downloadURL,
  }) : super(key: key);

  @override
  _UpdaterState createState() => _UpdaterState();
}

class _UpdaterState extends State<Updater> {
  bool accepted = false;
  String progress = '0';
  OtaStatus status = OtaStatus.DOWNLOADING;

  void ota() {
    setState(() => accepted = true);

    try {
      OtaUpdate()
          .execute(widget.downloadURL, destinationFilename: 'animu-release.apk')
          .listen(
        (OtaEvent event) {
          setState(() {
            progress = event.value;
            status = event.status;
          });
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!accepted)
      return AlertDialog(
        title: Text('Animú ${widget.latestVersion.toString()}'),
        content: Text('Actualizá de la última versión de Animú'),
        actions: <Widget>[
          DialogButton(
            label: 'Más tarde',
            onPressed: () => Navigator.pop(context),
          ),
          DialogButton(
            label: 'Actualizar',
            onPressed: ota,
          ),
        ],
      );
    else {
      String content = '';

      if (status == OtaStatus.DOWNLOADING)
        content = 'Descargando: $progress%';
      else if (status == OtaStatus.INSTALLING)
        content = 'Instalando';
      else if (status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR)
        content = 'Flaco, no me diste los permismos. Ahora jorobate';
      else if (status == OtaStatus.INTERNAL_ERROR)
        content = 'Este... "error"... pasaron cosas, viste';

      return AlertDialog(
        title: Text('Nueva versión'),
        content: Text(content),
      );
    }
  }
}
