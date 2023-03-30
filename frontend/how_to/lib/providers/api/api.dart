import 'dart:convert';

import 'package:how_to/providers/api/user.dart';
import 'package:how_to/providers/constants.dart';
import 'package:http/http.dart' as http;

abstract class API {
  static Future<http.Response> get({
    required String path,
  }) async {
    final loginData = await UserCtrls.getLoginData();
    return await http.get(
      Uri.http(Constants.domain, path),
      // headers: loginData.isLoggedIn
      //     ? {"Authorization": "Bearer ${loginData.token}"}
      //     : null,
    );
  }

  static Future<http.Response> post({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final loginData = await UserCtrls.getLoginData();
    return await http.post(
      Uri.http(Constants.domain, path),
      body: jsonEncode(body),
      headers: loginData.isLoggedIn
          ? {"Authorization": "Bearer ${loginData.token}"}
          : null,
    );
  }

  static Future<http.Response> put({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final loginData = await UserCtrls.getLoginData();
    return await http.put(
      Uri.http(Constants.domain, path),
      body: jsonEncode(body),
      headers: loginData.isLoggedIn
          ? {"Authorization": "Bearer ${loginData.token}"}
          : null,
    );
  }
}
