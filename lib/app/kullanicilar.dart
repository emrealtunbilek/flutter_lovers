import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanicilar"),
      ),
      body: FutureBuilder<List<User>>(
          future: _userModel.getAllUser(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumKullanicilar = sonuc.data;

              if (tumKullanicilar.length - 1 > 0) {
                return ListView.builder(
                  itemCount: tumKullanicilar.length,
                  itemBuilder: (context, index) {
                    var oankiUser = sonuc.data[index];
                    if (oankiUser.userID != _userModel.user.userID) {
                      return ListTile(
                        title: Text(oankiUser.userName),
                        subtitle: Text(oankiUser.email),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(oankiUser.profilURL),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return Center(
                  child: Text("Kayıtlı bir kullanıcı yok"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
