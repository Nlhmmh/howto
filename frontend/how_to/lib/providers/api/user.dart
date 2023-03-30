import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:how_to/providers/api/api.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';
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

  static Future<LoginData> login(Map<String, String> reqBody) async {
    final resp = await API.post(
      path: "/api/user/login",
      body: reqBody,
    );
    final loginData = LoginData.fromJson(jsonDecode(resp.body));
    await storeLoginData(loginData);
    return loginData;
  }

  static Future<UserProfile> fetchProfile(
    BuildContext context,
    Function(ErrorResp) cbFunc,
  ) async {
    final resp = await API.get(path: "/api/user/profile");
    final tmp = UserProfile.fromJson(jsonDecode(resp.body));
    cbFunc(tmp.errResp);
    return tmp;
  }

  // -----------------------------------------------

}
