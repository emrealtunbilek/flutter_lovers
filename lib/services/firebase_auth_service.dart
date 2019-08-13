import 'package:flutter_lovers/model/user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  @override
  Future<User> currentUser() {
    return null;
  }

  @override
  Future<bool> signOut() {
    return null;
  }

  @override
  Future<User> singInAnonymously() {
    return null;
  }
}
