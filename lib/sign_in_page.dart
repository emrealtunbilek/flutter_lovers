import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/common_widget/social_log_in_button.dart';

class SignInPage extends StatelessWidget {
  final Function(FirebaseUser) onSingIn;

  const SignInPage({Key key, @required this.onSingIn}) : super(key: key);

  void _misafirGirisi() async {
    AuthResult sonuc = await FirebaseAuth.instance.signInAnonymously();
    onSingIn(sonuc.user);
    print("Oturum açan user id:" + sonuc.user.uid.toString());
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
