import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:login_test/exceptions/unauthorized_exception.dart';
import 'dart:convert';
import 'auth_service.dart';

class ApiService {
  static const baseUrl = 'http://192.168.0.104:8003';

  Future<Map> get(String action, BuildContext context) async {
    final http.Response response =
        await http.get(Uri.parse(baseUrl + action), headers: {
      'Authorization': 'Bearer ${await AuthService().getAccessToken()}',
    });

    if (response.statusCode == 401) {
      await _refresh();

      final http.Response repeatedResponse =
          await http.get(Uri.parse(baseUrl + action), headers: {
        'Authorization': 'Bearer ${await AuthService().getAccessToken()}',
      });

      if (repeatedResponse.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      }

      return json.decode(repeatedResponse.body);
    }

    return json.decode(response.body);
  }

  Future<Map> post(String action, BuildContext context, Map data) async {
    final http.Response response = await http.post(
      Uri.parse(baseUrl + action),
      headers: {
        'Authorization': 'Bearer ${await AuthService().getAccessToken()}',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 401) {
      await _refresh();

      final http.Response repeatedResponse = await http.post(
        Uri.parse(baseUrl + action),
        headers: {
          'Authorization': 'Bearer ${await AuthService().getAccessToken()}',
        },
        body: json.encode(data),
      );

      if (repeatedResponse.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      }

      return json.decode(repeatedResponse.body);
    }

    return json.decode(response.body);
  }

  Future _refresh() async {
    final http.Response refreshResponse =
        await http.post(Uri.parse(baseUrl + '/api/auth/refresh_token'),
            body: json.encode({
              'refresh_token': await AuthService().getRefreshToken(),
            }));

    if (refreshResponse.statusCode == 401) {
      throw UnauthorizedException('Unauthorized');
    }

    var refreshData = json.decode(refreshResponse.body);

    await AuthService()
        .save(refreshData['access_token'], refreshData['refresh_token']);
  }
}
