import 'package:flutter/material.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/repository/user_repository.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<User> _tumKullanicilar;
  User _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 8;

  UserRepository _userRepository = locator<UserRepository>();
  List<User> get kullanicilarListesi => _tumKullanicilar;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser);
  }

  getUserWithPagination(User enSonGetirilenUser) async {
    if (_tumKullanicilar.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar.last;
      print("en son getirilen username:" + _enSonGetirilenUser.userName);
    }

    state = AllUserViewState.Busy;
    _tumKullanicilar = await _userRepository.getUserwithPagination(
        enSonGetirilenUser, sayfaBasinaGonderiSayisi);
    state = AllUserViewState.Loaded;
    _tumKullanicilar
        .forEach((usr) => print("Getirilen username:" + usr.userName));
  }

  Future<void> dahaFazlaUserGetir() async {
    print("Daha fazla user getir tetiklendi - viewmodeldeyiz -");
    await Future.delayed(Duration(seconds: 2));
    getUserWithPagination(_enSonGetirilenUser);
  }
}
