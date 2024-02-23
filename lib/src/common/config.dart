// ignore_for_file: constant_identifier_names

import 'package:package_info_plus/package_info_plus.dart';

class Config {
  ///  This is the app name as used everywhere in the application
  ///  Change it to your prefered name
  static const String appName = 'Bera Care';

  /// Change it to your best preferred store slogan
  static String appSlogan = '...';

  /// Change to latest app version
  static const String appVersion = '1.1.4';

  static const String mapsApiKey = '';

  static const String currency = 'UGX';

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

class MessageType {
  static const TEXT = 0;
  static const IMAGE = 1;
  static const VIDEO = 2;
  static const AUDIO = 3;
  static const DOCUMENT = 4;
  static const CONTACT = 5;
  static const LOCATION = 6;
}
