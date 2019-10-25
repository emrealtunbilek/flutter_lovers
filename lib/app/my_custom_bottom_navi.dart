import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/admob_islemleri.dart';
import 'package:flutter_lovers/app/tab_items.dart';

class MyCustomBottomNavigation extends StatefulWidget {
  const MyCustomBottomNavigation(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.sayfaOlusturucu,
      @required this.navigatorKeys})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  _MyCustomBottomNavigationState createState() =>
      _MyCustomBottomNavigationState();
}

class _MyCustomBottomNavigationState extends State<MyCustomBottomNavigation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AdmobIslemleri.admobInitialize();
    if (AdmobIslemleri.myBannerAd == null) {
      print("my banner null atanacak");
    }

    //myBannerAd.load();
  }

  @override
  void dispose() {
    if (AdmobIslemleri.myBannerAd != null) {
      AdmobIslemleri.myBannerAd.dispose();
      AdmobIslemleri.myBannerAd = null;
      print("my banner null oldu");
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlustur(TabItem.Kullanicilar),
          _navItemOlustur(TabItem.Konusmalarim),
          _navItemOlustur(TabItem.Profil),
        ],
        onTap: (index) => widget.onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final gosterilecekItem = TabItem.values[index];
        return CupertinoTabView(
            navigatorKey: widget.navigatorKeys[gosterilecekItem],
            builder: (context) {
              return widget.sayfaOlusturucu[gosterilecekItem];
            });
      },
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(olusturulacakTab.icon),
      title: Text(olusturulacakTab.title),
    );
  }
}
