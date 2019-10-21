import 'package:flutter_lovers/model/mesaj.dart';
import 'package:flutter_lovers/model/user.dart';

class BildirimGondermeServis {
  Future<bool> bildirimGonder(
      Mesaj gonderilecekBildirim, User gonderenUser, String token) {
    String endURL = "https://fcm.googleapis.com/fcm/send";
  }
}
