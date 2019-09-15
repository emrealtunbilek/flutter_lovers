import 'package:flutter/material.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _userModel.getAllUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanicilar"),
      ),
      body: Center(
        child: Text("Tüm kullanıcılar"),
      ),
    );
  }
}
