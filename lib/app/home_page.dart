import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/admob_islemleri.dart';
import 'package:flutter_lovers/app/konusmalarim_page.dart';
import 'package:flutter_lovers/app/kullanicilar.dart';
import 'package:flutter_lovers/app/my_custom_bottom_navi.dart';
import 'package:flutter_lovers/app/profil.dart';
import 'package:flutter_lovers/app/tab_items.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/notification_handler.dart';
import 'package:flutter_lovers/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        builder: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (AdmobIslemleri.myBannerAd != null &&
              AdmobIslemleri.myBannerAd.id != null) {
            print(
                " #################### banner null değil dispose edilecek ######################");
            try {
              AdmobIslemleri.myBannerAd.dispose();
              AdmobIslemleri.myBannerAd = null;
            } catch (e) {
              print("hata:" + e.toString());
            }
          }

          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
