import 'package:animu/utils/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class BackupService {
  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();
  static final _db = Firestore.instance;

  static Future<FirebaseUser> get user => _auth.currentUser();
  static Stream<FirebaseUser> get userStream => _auth.onAuthStateChanged;

  static Future<FirebaseUser> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final googleCredential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(googleCredential);
      return await _auth.currentUser();
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

  static void uploadToDB(Box<Anime> box) async {
    final u = await user;
    if (u == null) return;

    await _db.document('users/${u.uid}').setData({
      'animes': box.toMap().map<String, Map>((id, anime) {
        return new MapEntry(id.toString(), anime.toMap(true));
      }),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
