import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/sohbet_page.dart';
import 'package:flutter_lovers/model/konusma.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Konusmalarım"),
      ),
      body: FutureBuilder<List<Konusma>>(
        future: _userModel.getAllConversations(_userModel.user.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;

            return RefreshIndicator(
              onRefresh: _konusmalarimListesiniYenile,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var oankiKonusma = tumKonusmalar[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => SohbetPage(
                            currentUser: _userModel.user,
                            sohbetEdilenUser: User.idveResim(
                                userID: oankiKonusma.kimle_konusuyor,
                                profilURL: oankiKonusma.konusulanUserProfilURL),
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(oankiKonusma.son_yollanan_mesaj),
                      subtitle: Text(oankiKonusma.konusulanUserName),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(oankiKonusma.konusulanUserProfilURL),
                      ),
                    ),
                  );
                },
                itemCount: tumKonusmalar.length,
              ),
            );
          }
        },
      ),
    );
  }

  void _konusmalarimiGetir() async {
    final _userModel = Provider.of<UserModel>(context);
    var konusmalarim = await Firestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.user.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    for (var konusma in konusmalarim.documents) {
      print("konusma:" + konusma.data.toString());
    }
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
