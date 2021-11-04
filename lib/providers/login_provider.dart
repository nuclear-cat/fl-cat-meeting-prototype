import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:login_test/services/auth_service.dart';
import 'package:device_info/device_info.dart';
import 'package:login_test/services/device_info_service.dart';

class LoginProvider extends ChangeNotifier {
  String? _accessToken;
  String? _refreshToken;

  bool isLoading = false;

  Future login(String email, String password) async {
    var url = Uri.parse('http://192.168.0.104:8003/api/auth/login');
    isLoading = true;

    notifyListeners();

    try {
      var response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'device_id': await DeviceInfoService().getDeviceId(),
          }));

      var responseData = json.decode(response.body.toString());

      AuthService()
          .save(responseData['access_token'], responseData['refresh_token']);
    } catch (_) {
      isLoading = false;
      notifyListeners();

      rethrow;
    }

    notifyListeners();
  }
}
