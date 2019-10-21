import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/konusma.dart';
import 'package:flutter_lovers/model/mesaj.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/repository/user_repository.dart';
import 'package:flutter_lovers/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  User _user;
  String emailHataMesaji;
  String sifreHataMesaji;

  User get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<User> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> singInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInAnonymously();
      return _user;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      if (_user != null)
        return _user;
      else {
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.createUserWithEmailandPassword(email, sifre);

        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailandPassword(email, sifre);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;

    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalı";
      sonuc = false;
    } else
      sifreHataMesaji = null;
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
    } else
      emailHataMesaji = null;
    return sonuc;
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, yeniUserName);
    if (sonuc) {
      _user.userName = yeniUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var indirmeLinki =
        await _userRepository.uploadFile(userID, fileType, profilFoto);
    return indirmeLinki;
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    return _userRepository.getMessages(currentUserID, sohbetEdilenUserID);
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    return await _userRepository.getAllConversations(userID);
  }
}
