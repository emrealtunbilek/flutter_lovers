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
}
