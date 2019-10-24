import 'package:firebase_admob/firebase_admob.dart';

class AdmobIslemleri {
  static final String appIDCanli = "ca-app-pub-6683595221234017~8436710258";
  static final String appIDTest = FirebaseAdMob.testAppId;

  static final String banner1Canli = "ca-app-pub-6683595221234017/3327622295";

  static admobInitialize() {
    FirebaseAdMob.instance.initialize(appId: appIDTest);
  }

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutter', 'chat app'],
    contentUrl: 'https://emrealtunbilek.com',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  static BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          print("Banner yüklendi");
        }
      },
    );
  }
}
