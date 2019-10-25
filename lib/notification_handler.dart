import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_lovers/app/sohbet_page.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/viewmodel/chat_view_model.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    //print("Arka planda gelen data:" + message["data"].toString());
    NotificationHandler.showNotification(message);
  }

  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();

  static final NotificationHandler _singleton = NotificationHandler._internal();
  factory NotificationHandler() {
    return _singleton;
  }
  NotificationHandler._internal();
  BuildContext myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    /*_fcm.subscribeToTopic("spor");

    String token = await _fcm.getToken();
    print("token :" + token);
    */
    _fcm.onTokenRefresh.listen((newToken) async {
      FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
      await Firestore.instance
          .document("tokens/" + _currentUser.uid)
          .setData({"token": newToken});
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        //print("onMessage tetiklendi: $message");
        showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch tetiklendi: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume tetiklendi: $message");
      },
    );
  }

  static void showNotification(Map<String, dynamic> message) async {
    //var userURLPath =
    await _downloadAndSaveImage(message["data"]["profilURL"], 'largeIcon');

    var mesaj = Person(
        name: message["data"]["title"],
        key: '1',
        //icon: userURLPath,
        iconSource: IconSource.FilePath);
    var mesajStyle = MessagingStyleInformation(mesaj,
        messages: [Message(message["data"]["message"], DateTime.now(), mesaj)]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1234', 'Yeni Mesaj', 'your channel description',
        style: AndroidNotificationStyle.Messaging,
        styleInformation: mesajStyle,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message["data"]["title"],
        message["data"]["message"], platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  Future onSelectNotification(String payload) async {
    final _userModel = Provider.of<UserModel>(myContext);

    if (payload != null) {
      // debugPrint('notification payload: ' + payload);

      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);

      Navigator.of(myContext, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            builder: (context) => ChatViewModel(
                currentUser: _userModel.user,
                sohbetEdilenUser: User.idveResim(
                    userID: gelenBildirim["data"]["gonderenUserID"],
                    profilURL: gelenBildirim["data"]["profilURL"])),
            child: SohbetPage(),
          ),
        ),
      );
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  static _downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
