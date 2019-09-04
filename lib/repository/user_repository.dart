import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_lovers/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> singInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInAnonymously();
    } else {
      return await _firebaseAuthService.singInAnonymously();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      User _user = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return _user;
      } else
        return null;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithFacebook();
    } else {
      User _user = await _firebaseAuthService.signInWithFacebook();
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return _user;
      } else
        return null;
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserWithEmailandPassword(
          email, sifre);
    } else {
      User _user = await _firebaseAuthService.createUserWithEmailandPassword(
          email, sifre);
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithEmailandPassword(
          email, sifre);
    } else {
      User _user =
          await _firebaseAuthService.signInWithEmailandPassword(email, sifre);

      return await _firestoreDBService.readUser(_user.userID);
    }
  }
}
