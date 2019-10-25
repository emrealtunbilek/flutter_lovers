import 'package:flutter_lovers/model/mesaj.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:http/http.dart' as http;

class BildirimGondermeServis {
  Future<bool> bildirimGonder(
      Mesaj gonderilecekBildirim, User gonderenUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAAazL8mbM:APA91bEf09Tjw4AgwXYXEVaZYuvT_vw0ax-nPXOMqABZzJx2fl4ssfiA3D0X8vL2ivvv0pbDVcGzUuP04yKFF_iLMTlL2EKDAIy_GvD_Y1AXcSZKPKad37DCdwN6Gya4r5SVgzkormBz";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey"
    };

    String json =
        '{ "to" : "$token", "data" : { "message" : "${gonderilecekBildirim.mesaj}", "title": "${gonderenUser.userName} yeni mesaj", "profilURL": "${gonderenUser.profilURL}", "gonderenUserID" : "${gonderenUser.userID}" } }';

    http.Response response =
        await http.post(endURL, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("işlem basarılı");
    } else {
      /*print("işlem basarısız:" + response.statusCode.toString());
      print("jsonumuz:" + json);*/
    }
  }
}
