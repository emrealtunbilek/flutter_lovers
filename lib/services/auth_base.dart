import 'package:flutter_lovers/model/user.dart';

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> singInAnonymously();
  Future<bool> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailandPassword(String email, String sifre);
  Future<User> createUserWithEmailandPassword(String email, String sifre);
}
