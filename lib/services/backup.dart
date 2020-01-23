import 'package:animu/services/requests.dart';
import 'package:animu/utils/helpers.dart';
import 'package:animu/utils/models.dart';
import 'package:animu/widgets/dialog_button.dart';
import 'package:animu/widgets/spinner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class BackupService {
  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();
  static final _db = Firestore.instance;

  static Future<FirebaseUser> get user => _auth.currentUser();
  static Stream<FirebaseUser> get userStream => _auth.onAuthStateChanged;
  static Future<DocumentReference> get userDocument async {
    final u = await user;
    if (u == null) return null;
    return _db.document('users/${u.uid}');
  }

  static Future<FirebaseUser> signIn(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(googleCredential);

      final docReference = await userDocument;
      if (docReference != null) {
        final doc = await docReference.get();
        if (doc.exists) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => WillPopScope(
              onWillPop: () async => false,
              child: _BackupFound(doc),
            ),
          );
        }
      }
      return await user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static void uploadToDB() async {
    final u = await user;
    if (u == null) return;

    final animes = Hive.box<Anime>('animes');

    await _db.document('users/${u.uid}').setData({
      'animes': animes.toMap().map<String, Map>(
        (id, anime) {
          return new MapEntry(id.toString(), anime.toMap(true));
        },
      ),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static void restore(dynamic data) async {
    final u = await user;
    if (u == null) return;

    final animes = new List<Anime>.from(
      data['animes']
          .values
          .map((map) => Anime.fromMap(Map<String, dynamic>.from(map))),
    );

    await Future.wait(animes.map(getAnimes));
  }

  static Future getAnimes(Anime anime) async {
    final newData = await RequestsService.getAnime(anime);
    final mergedAnimeMap = {
      ...newData.toMap()..removeWhere((_, value) => value == null),
      ...anime.toMap(true)..removeWhere((_, value) => value == null),
    };
    final finalAnime = Anime.fromMap(mergedAnimeMap);

    Hive.box<Anime>('animes').put(finalAnime.id, finalAnime);
  }
}

class _BackupFound extends StatefulWidget {
  final DocumentSnapshot doc;

  const _BackupFound(this.doc, {Key key}) : super(key: key);

  @override
  __BackupFoundState createState() => __BackupFoundState();
}

class __BackupFoundState extends State<_BackupFound> {
  bool loading = false;

  void run(Function f) async {
    setState(() => loading = true);
    await f();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final date = formatDay(widget.doc.data['updatedAt'].toDate());

    if (loading)
      return Dialog(
        child: SizedBox(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spinner(size: 25),
              SizedBox(width: 15),
              Text('Cargando...'),
            ],
          ),
        ),
      );

    return AlertDialog(
      title: Text('Copia encontrada'),
      content: Text(
        'Se ha encontrado una copia de seguridad vinculada a esta cuenta del $date. Podés: \n\n' +
            'A) Recuperar la copia y borrar los animes que tengas localmente\n' +
            'B) Borrar la copia y subir los animes que tenés localmetne\n' +
            'C) No hacer nada',
      ),
      actions: <Widget>[
        DialogButton(
          label: 'A - Recuperar',
          onPressed: () {
            run(() async => BackupService.restore(widget.doc.data));
          },
        ),
        DialogButton(
          label: 'B - Borrar',
          onPressed: () {
            run(BackupService.uploadToDB);
          },
        ),
        DialogButton(
          label: 'C - Cancelar',
          onPressed: () {
            run(BackupService.signOut);
          },
        ),
      ],
    );
  }
}
