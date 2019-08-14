import 'package:flutter/material.dart';
import 'package:flutter_lovers/common_widget/social_log_in_button.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';

class SignInPage extends StatelessWidget {
  final Function(User) onSingIn;
  AuthBase authService = locator<FirebaseAuthService>();

  SignInPage({Key key, @required this.onSingIn}) : super(key: key);

  void _misafirGirisi() async {
    User _user = await authService.singInAnonymously();
    onSingIn(_user);
    print("Oturum açan user id:" + _user.userID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Lovers"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),
            SocialLoginButton(
              butonText: "Gmail ile Giriş Yap",
              textColor: Colors.black87,
              butonColor: Colors.white,
              butonIcon: Image.asset("images/google-logo.png"),
              onPressed: () {},
            ),
            SocialLoginButton(
              butonText: "Facebook ile Giriş Yap",
              butonIcon: Image.asset("images/facebook-logo.png"),
              onPressed: () {},
              butonColor: Color(0xFF334D92),
            ),
            SocialLoginButton(
              onPressed: () {},
              butonIcon: Icon(
                Icons.email,
                color: Colors.white,
                size: 32,
              ),
              butonText: "Email ve Şifre ile Giriş yap",
            ),
            SocialLoginButton(
              onPressed: _misafirGirisi,
              butonColor: Colors.teal,
              butonIcon: Icon(Icons.supervised_user_circle),
              butonText: "Misafir Girişi",
            ),
          ],
        ),
      ),
    );
  }
}
