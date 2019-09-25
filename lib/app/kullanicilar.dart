import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  List<User> _tumKullanicilar = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _getirilecekElemanSayisi = 10;
  User _enSonGetirilenUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser(_enSonGetirilenUser);
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position == 0) {
          print("En tepedeyiz");
        } else {
          print("listenin sonundayız");
          getUser(_enSonGetirilenUser);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanicilar"),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  await getUser(_enSonGetirilenUser);
                },
                child: Text("Next Users"))
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: _tumKullanicilar.length == 0
                    ? Center(
                        child: Text("Kullanıcı yok"),
                      )
                    : _kullaniciListesiniOlustur()),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
          ],
        ));
  }

  getUser(User enSonGetirilenUser) async {
    if (!_hasMore) {
      print(
          "Getirilecek eleman kalmadı o yüzden firestore rahatsız edilmeyecek");
      return;
    }
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    QuerySnapshot _querySnapshot;

    if (enSonGetirilenUser == null) {
      print("İlk defa kullanıcılar getiriliyor");
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(_getirilecekElemanSayisi)
          .getDocuments();
    } else {
      print("Sonraki kullanıcılar getiriliyor");
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(_getirilecekElemanSayisi)
          .getDocuments();
    }

    if (_querySnapshot.documents.length < _getirilecekElemanSayisi) {
      _hasMore = false;
    }

    for (DocumentSnapshot snap in _querySnapshot.documents) {
      User _tekUser = User.fromMap(snap.data);
      _tumKullanicilar.add(_tekUser);
      print("Getirilen user name:" + _tekUser.userName);
    }

    _enSonGetirilenUser = _tumKullanicilar.last;
    print("en son getirilen user name:" + _enSonGetirilenUser.userName);

    setState(() {
      _isLoading = false;
    });
  }

  _kullaniciListesiniOlustur() {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_tumKullanicilar[index].userName),
        );
      },
      itemCount: _tumKullanicilar.length,
    );
  }
}
