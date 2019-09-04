import 'package:flutter_lovers/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(User user);
  Future<User> readUser(String userID);
}
