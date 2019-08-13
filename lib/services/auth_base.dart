import 'package:flutter_lovers/model/user_model.dart';

abstract class AuthBase {
  Future<User> currentUser();
  Future<User> singInAnonymously();
  Future<bool> signOut();
}
