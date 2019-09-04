import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "123123123123123213123123123";

  @override
  Future<User> currentUser() async {
    return await Future.value(User(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<User> singInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),
        () => User(userID: userID, email: "fakeuser@fake.com"));
  }

  @override
  Future<User> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            User(userID: "google_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<User> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => User(
            userID: "facebook_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<User> createUserWithEmailandPassword(
      String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            User(userID: "created_user_id_123456", email: "fakeuser@fake.com"));
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () =>
            User(userID: "signIn_user_id_123456", email: "fakeuser@fake.com"));
  }
}
