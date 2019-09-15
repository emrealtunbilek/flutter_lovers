import 'package:cloud_firestore/cloud_firestore.dart';
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
}
