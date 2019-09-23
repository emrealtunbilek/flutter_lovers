import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lovers/model/konusma.dart';
import 'package:flutter_lovers/model/mesaj.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final Firestore _firebaseDB = Firestore.instance;

  @override
  Future<bool> saveUser(User user) async {
    await _firebaseDB
        .collection("users")
        .document(user.userID)
        .setData(user.toMap());

    DocumentSnapshot _okunanUser =
        await Firestore.instance.document("users/${user.userID}").get();

    Map _okunanUserBilgileriMap = _okunanUser.data;
    User _okunanUserBilgileriNesne = User.fromMap(_okunanUserBilgileriMap);
    print("Okunan user nesnesi :" + _okunanUserBilgileriNesne.toString());
    return true;
  }

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection("users").document(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data;

    User _okunanUserNesnesi = User.fromMap(_okunanUserBilgileriMap);
    print("Okunan user nesnesi :" + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firebaseDB
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .getDocuments();
    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .document(userID)
          .updateData({'userName': yeniUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await _firebaseDB
        .collection("users")
        .document(userID)
        .updateData({'profilURL': profilFotoURL});
    return true;
  }

  @override
  Future<List<User>> getAllUser() async {
    QuerySnapshot querySnapshot =
        await _firebaseDB.collection("users").getDocuments();

    List<User> tumKullanicilar = [];
    for (DocumentSnapshot tekUser in querySnapshot.documents) {
      User _tekUser = User.fromMap(tekUser.data);
      tumKullanicilar.add(_tekUser);
    }

    //MAP METOTU ILE
    //tumKullanicilar = querySnapshot.documents.map((tekSatir)=>User.fromMap(tekSatir.data)).toList();

    return tumKullanicilar;
  }

  @override
  Future<List<Konusma>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDB
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    List<Konusma> tumKonusmalar = [];

    for (DocumentSnapshot tekKonusma in querySnapshot.documents) {
      Konusma _tekKonusma = Konusma.fromMap(tekKonusma.data);
      print("okunan konusma tarisi:" +
          _tekKonusma.olusturulma_tarihi.toDate().toString());
      tumKonusmalar.add(_tekKonusma);
    }

    return tumKonusmalar;
  }

  /*
  @override
  Stream<Mesaj> getMessage(String currentUserID, String sohbetEdilenUserID) {
    var snapShot = _firebaseDB
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .document(currentUserID)
        .snapshots();


    return snapShot.map((snapShot)=>Mesaj.fromMap(snapShot.data));
  }
*/

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    var snapShot = _firebaseDB
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();
    return snapShot.map((mesajListesi) => mesajListesi.documents
        .map((mesaj) => Mesaj.fromMap(mesaj.data))
        .toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firebaseDB.collection("konusmalar").document().documentID;
    var _myDocumentID =
        kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;

    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();

    await _firebaseDB
        .collection("konusmalar")
        .document(_myDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    await _firebaseDB.collection("konusmalar").document(_myDocumentID).setData({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajMapYapisi.update("bendenMi", (deger) => false);

    await _firebaseDB
        .collection("konusmalar")
        .document(_receiverDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    await _firebaseDB
        .collection("konusmalar")
        .document(_receiverDocumentID)
        .setData({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firebaseDB.collection("server").document(userID).setData({
      "saat": FieldValue.serverTimestamp(),
    });

    var okunanMap =
        await _firebaseDB.collection("server").document(userID).get();
    Timestamp okunanTarih = okunanMap.data["saat"];
    return okunanTarih.toDate();
  }
}
