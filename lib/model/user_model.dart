import 'package:flutter/material.dart';

class User {
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  DateTime updatedAt;
  int seviye;

  User({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ?? '',
      'profilURL': profilURL ??
          'https://emrealtunbilek.com/wp-content/uploads/2016/10/apple-icon-72x72.png',
      'createdAt': createdAt ?? '',
      'updatedAt': updatedAt ?? '',
      'seviye': seviye ?? 1,
    };
  }
}
