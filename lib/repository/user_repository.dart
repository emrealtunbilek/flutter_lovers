import 'dart:io';

import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/model/konusma.dart';
import 'package:flutter_lovers/model/mesaj.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/services/auth_base.dart';
import 'package:flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_lovers/services/firebase_storage_service.dart';
import 'package:flutter_lovers/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<User> tumKullaniciListesi = [];

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      User _user = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> singInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInAnonymously();
    } else {
      return await _firebaseAuthService.singInAnonymously();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      User _user = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithFacebook();
    } else {
      User _user = await _firebaseAuthService.signInWithFacebook();
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserWithEmailandPassword(
          email, sifre);
    } else {
      User _user = await _firebaseAuthService.createUserWithEmailandPassword(
          email, sifre);
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else
        return null;
    }
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithEmailandPassword(
          email, sifre);
    } else {
      User _user =
          await _firebaseAuthService.signInWithEmailandPassword(email, sifre);

      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoURL);
      return profilFotoURL;
    }
  }

  Future<List<User>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _firestoreDBService.getAllUser();

      return tumKullaniciListesi;
    }
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveMessage(kaydedilecekMesaj);
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var konusmaListesi =
          await _firestoreDBService.getAllConversations(userID);

      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeUserBul(oankiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          print("VERILER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfilURL =
              userListesindekiKullanici.profilURL;
        } else {
          print("VERILER VERITABANINDAN OKUNDU");
          print(
              "aranılan user daha önceden veritabanından getirilmemiş, o yüzden veritabanından bu degeri okumalıyız");
          var _veritabanindanOkunanUser =
              await _firestoreDBService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
          oankiKonusma.konusulanUserProfilURL =
              _veritabanindanOkunanUser.profilURL;
        }
      }

      return konusmaListesi;
    }
  }

  User listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userID == userID) {
        return tumKullaniciListesi[i];
      }
    }

    return null;
  }
}
