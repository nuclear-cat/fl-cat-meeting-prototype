import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DeviceInfoService {
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return androidInfo.androidId;
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.identifierForVendor;
    }

    return '';
  }
}
