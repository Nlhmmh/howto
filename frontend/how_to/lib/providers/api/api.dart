import 'dart:convert';
import 'dart:io';

import 'package:how_to/providers/api/user_ctrls.dart';
import 'package:how_to/providers/constants.dart';
import 'package:http/http.dart' as http;

abstract class API {
  static Future<http.Response> get({
    required String path,
    Map<String, dynamic>? params,
  }) async {
    final loginData = await UserCtrls.getLoginData();
    return await http.get(
      Uri.http(Constants.domain, path, params),
      headers: loginData.isLoggedIn
          ? {"Authorization": "Bearer ${loginData.token}"}
          : null,
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

  static Future<http.Response> delete({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final loginData = await UserCtrls.getLoginData();
    return await http.delete(
      Uri.http(Constants.domain, path),
      body: jsonEncode(body),
      headers: loginData.isLoggedIn
          ? {"Authorization": "Bearer ${loginData.token}"}
          : null,
    );
  }

  static Future<http.StreamedResponse> postMultipart({
    required String path,
    required File file,
  }) async {
    final loginData = await UserCtrls.getLoginData();
    final request = http.MultipartRequest(
      "POST",
      Uri.http(Constants.domain, path),
    );
    final multipartFile = await http.MultipartFile.fromPath(
      "file",
      file.path,
    );
    request.headers.addAll({"Authorization": "Bearer ${loginData.token}"});
    request.files.add(multipartFile);
    return await request.send();
  }
}
