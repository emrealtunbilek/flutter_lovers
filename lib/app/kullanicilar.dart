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
  List<User> _tumKullanicilar;
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
      body: _tumKullanicilar == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _kullaniciListesiniOlustur(),
    );
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

      _tumKullanicilar = [];
    } else {
      print("Sonraki kullanıcılar getiriliyor");
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(_getirilecekElemanSayisi)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
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
        print("index değeri:" +
            index.toString() +
            " listedeki eleman sayisi:" +
            _tumKullanicilar.length.toString());

        if (index == _tumKullanicilar.length) {
          print("yeni elemanlar bekleniyor");
          return _yeniElemanlarYukleniyorIndicator();
        }
        return ListTile(
          title: Text(_tumKullanicilar[index].userName),
        );
      },
      itemCount: _tumKullanicilar.length + 1,
    );
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Opacity(
          opacity: _isLoading ? 1 : 0,
          child: _isLoading ? CircularProgressIndicator() : null,
        ),
      ),
    );
  }
}
