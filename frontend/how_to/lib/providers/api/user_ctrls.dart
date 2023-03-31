import 'dart:convert';

import 'package:how_to/providers/api/api.dart';
import 'package:how_to/providers/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserCtrls {
  static const prefLoginData = "loginData";

  // -------------------------------

  static Future<LoginData> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final loginData = prefs.getString(prefLoginData);
    if (loginData != null) {
      Map<String, dynamic> userMap = jsonDecode(loginData);
      return LoginData.fromJson(userMap);
    }
    return LoginData();
  }

  static Future<void> storeLoginData(LoginData loginData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "loginData",
      jsonEncode(loginData.toJson()),
    );
  }

  static Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefLoginData);
  }

  // -------------------------------

  static Future<ErrorResp> register(Map<String, String> reqBody) async {
    final resp = await API.post(
      path: "/api/user/register",
      body: reqBody,
    );
    final errorResp = ErrorResp.fromJson(jsonDecode(resp.body));
    return errorResp;
  }

  static Future<LoginData> login(Map<String, String> reqBody) async {
    final resp = await API.post(
      path: "/api/user/login",
      body: reqBody,
    );
    final loginData = LoginData.fromJson(jsonDecode(resp.body));
    await storeLoginData(loginData);
    return loginData;
  }

  static Future<UserProfile> fetchProfile(Function(ErrorResp) cbFunc) async {
    final resp = await API.get(path: "/api/user/profile");
    final tmp = UserProfile.fromJson(jsonDecode(resp.body));
    cbFunc(tmp.errResp);
    return tmp;
  }

  static Future<ErrorResp> editProfile(Map<String, String> reqBody) async {
    final resp = await API.put(
      path: "/api/user/edit/profile",
      body: reqBody,
    );
    final errorResp = ErrorResp.fromJson(jsonDecode(resp.body));
    return errorResp;
  }

  static Future<ErrorResp> editPassword(Map<String, String> reqBody) async {
    final resp = await API.post(
      path: "/api/user/edit/password",
      body: reqBody,
    );
    final errorResp = ErrorResp.fromJson(jsonDecode(resp.body));
    return errorResp;
  }

  // -----------------------------------------------

}
