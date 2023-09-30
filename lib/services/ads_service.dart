import 'dart:io';

class AdMobService {
  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'Rewarded_Android';
    } else if (Platform.isIOS) {
      return 'Rewarded_iOS';
    }

    return null;
  }

  static String? get rewardedAdunitIdGoogle {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1566237285206026/8944384435';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1566237285206026/9798897570';
    }
    return null;
  }

  /*

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => print("Ad Loaded"),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
    },
  );
  */
}
