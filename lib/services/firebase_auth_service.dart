import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    if (user == null) {
      return null;
    } else {
      return User(userID: user.uid, email: user.email);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();

      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

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

  @override
  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        AuthResult sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        FirebaseUser _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();

    FacebookLoginResult _faceResult = await _facebookLogin
        .logInWithReadPermissions(['public_profile', 'email']);

    switch (_faceResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (_faceResult.accessToken != null &&
            _faceResult.accessToken.isValid()) {
          AuthResult _firebaseResult = await _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.getCredential(
                  accessToken: _faceResult.accessToken.token));

          FirebaseUser _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        } else {
          /* print("access token valid :" +
              _faceResult.accessToken.isValid().toString());*/
        }

        break;

      case FacebookLoginStatus.cancelledByUser:
        print("kullanıcı facebook girişi iptal etti");
        break;

      case FacebookLoginStatus.error:
        print("Hata cıktı :" + _faceResult.errorMessage);
        break;
    }

    return null;
  }

  @override
  Future<User> createUserWithEmailandPassword(
      String email, String sifre) async {
    AuthResult sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    AuthResult sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }
}
