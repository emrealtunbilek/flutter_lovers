import 'package:flutter/material.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/user_model.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';

class HomePage extends StatelessWidget {
  final Function onSignOut;
  AuthBase authService = locator<FirebaseAuthService>();
  final User user;

  HomePage({Key key, @required this.user, @required this.onSignOut})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            onPressed: _cikisYap,
            child: Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
        title: Text("Ana Sayfa"),
      ),
      body: Center(
        child: Text("Hoşgeldiniz ${user.userID}"),
      ),
    );
  }

  Future<bool> _cikisYap() async {
    bool sonuc = await authService.signOut();
    onSignOut();
    return sonuc;
  }
}
