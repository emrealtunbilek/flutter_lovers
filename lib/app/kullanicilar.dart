import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_lovers/app/sohbet_page.dart';
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
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      getUser();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position == 0) {
          print("En tepedeyiz");
        } else {
          print("listenin sonundayız");
          getUser();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanicilar"),
      ),
      body: _tumKullanicilar == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _kullaniciListesiniOlustur(),
    );
  }

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

  Widget _userListeElemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context);
    var _oankiUser = _tumKullanicilar[index];

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

  Future<Null> _kullaniciListesiRefresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    getUser();
  }
}
