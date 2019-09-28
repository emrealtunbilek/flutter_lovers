import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/sohbet_page.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/viewmodel/all_users_view_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  bool _isLoading = false;
  bool _hasMore = true;
  int _getirilecekElemanSayisi = 10;
  User _enSonGetirilenUser;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      //minscrollextent listenin en sonu geldiğimizde olusur
      //maxscrollextent listenin en basına geldiğimizde olusur
      if (_scrollController.offset >=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        dahaFazlaKullaniciGetir();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _tumKullanicilarViewModel = Provider.of<AllUserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanicilar"),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return _userListeElemaniOlustur(index);
              },
              itemCount: model.kullanicilarListesi.length,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  /*
  getUser() async {
    final _userModel = Provider.of<UserModel>(context);

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

    List<User> _users = await _userModel.getUserwithPagination(
        _enSonGetirilenUser, _getirilecekElemanSayisi);

    if (_enSonGetirilenUser == null) {
      _tumKullanicilar = [];
      _tumKullanicilar.addAll(_users);
    } else {
      _tumKullanicilar.addAll(_users);
    }

    if (_users.length < _getirilecekElemanSayisi) {
      _hasMore = false;
    }

    _enSonGetirilenUser = _tumKullanicilar.last;

    setState(() {
      _isLoading = false;
    });
  }
*/
/*
  _kullaniciListesiniOlustur() {
    if (_tumKullanicilar.length > 1) {
      return RefreshIndicator(
        onRefresh: _kullaniciListesiRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == _tumKullanicilar.length) {
              return _yeniElemanlarYukleniyorIndicator();
            }
            return _userListeElemaniOlustur(index);
          },
          itemCount: _tumKullanicilar.length + 1,
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _kullaniciListesiRefresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.supervised_user_circle,
                    color: Theme.of(context).primaryColor,
                    size: 120,
                  ),
                  Text(
                    "Henüz Kullanıcı Yok",
                    style: TextStyle(fontSize: 36),
                  )
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height - 150,
          ),
        ),
      );
    }
  }
*/
  Widget _userListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context);
    final _tumKullanicilarViewModel = Provider.of<AllUserViewModel>(context);
    var _oankiUser = _tumKullanicilarViewModel.kullanicilarListesi[index];

    if (_oankiUser.userID == _userModel.user.userID) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => SohbetPage(
                    currentUser: _userModel.user,
                    sohbetEdilenUser: _oankiUser,
                  )),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(_oankiUser.userName),
          subtitle: Text(_oankiUser.email),
          leading: CircleAvatar(
            backgroundColor: Colors.grey.withAlpha(40),
            backgroundImage: NetworkImage(_oankiUser.profilURL),
          ),
        ),
      ),
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

  /*Future<Null> _kullaniciListesiRefresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    getUser();
  }*/

  void dahaFazlaKullaniciGetir() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _tumKullanicilarViewModel = Provider.of<AllUserViewModel>(context);
      await _tumKullanicilarViewModel.dahaFazlaUserGetir();
      _isLoading = false;
    }
  }
}
