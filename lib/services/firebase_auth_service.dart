import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lovers/model/user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(userID: user.uid);
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }

  @override
  Future<User> singInAnonymously() async {
    try {
      AuthResult sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("anonim giris hata:" + e.toString());
      return null;
    }
  }
}
