import 'package:animu/services/backup.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackupsSettings extends StatefulWidget {
  @override
  _BackupsSettingsState createState() => _BackupsSettingsState();
}

class _BackupsSettingsState extends State<BackupsSettings> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final signedIn = user != null;

    return Center(
      child: loading
          ? Spinner(size: 50)
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (signedIn)
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    signedIn
                        ? ('Conectado: ' + user.displayName)
                        : 'Desconectado',
                  ),
                ),
                RaisedButton(
                  child: Text(
                    signedIn ? 'Desconectarse' : 'Conectarse con Google',
                  ),
                  onPressed: () async {
                    setState(() => loading = true);
                    if (signedIn)
                      await BackupService.signOut();
                    else
                      await BackupService.signIn(context);
                    setState(() => loading = false);
                  },
                ),
              ],
            ),
    );
  }
}
