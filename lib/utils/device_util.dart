import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceUtil {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future getId() async {
    return await FlutterUdid.consistentUdid;
  }

  static Future getUdid() async {
    return await FlutterUdid.udid;
  }

  static Future getOs() async {
    var os = 'other';
    if (Platform.isAndroid) {
      os = 'android';
    }

    if (Platform.isIOS) {
      os = 'ios';
    }

    return os;
  }

  static Future getOsVersion() async {
    String? version = 'unknown';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      version = androidInfo.version.release;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      version = iosInfo.systemVersion;
    }

    return version;
  }

  static Future getManufacturer() async {
    String? manufacturer = 'other';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      manufacturer = androidInfo.manufacturer;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      manufacturer = iosInfo.name;
    }

    return manufacturer;
  }

  static Future getModel() async {
    String? model = 'other';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      model = iosInfo.model;
    }

    return model;
  }

  static Future getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
