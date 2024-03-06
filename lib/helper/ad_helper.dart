import 'dart:io';

import 'package:tasbih/constants.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return adMobBannerAdUnit;
    }else if (Platform.isIOS) {
      return adMobBannerAdUnit;
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}