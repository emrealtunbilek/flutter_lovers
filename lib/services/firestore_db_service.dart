import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lovers/model/user_model.dart';
import 'package:flutter_lovers/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final Firestore _firebaseAuth = Firestore.instance;

  @override
  Future<bool> saveUser(User user) async {
    Map _eklenecekUserMap = user.toMap();
    _eklenecekUserMap['createdAt'] = FieldValue.serverTimestamp();
    _eklenecekUserMap['updatedAt'] = FieldValue.serverTimestamp();

    await _firebaseAuth
        .collection("users")
        .document(user.userID)
        .setData(_eklenecekUserMap);
    
    DocumentSnapshot _okunanUser = await Firestore.instance.document("users/${user.userID}").get();

    _okunanUser.data
    
    
    
    
    return true;
  }
}
