import 'package:flutter/material.dart';

class User {
  final String userID;

  User({@required this.userID});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
    };
  }
}
