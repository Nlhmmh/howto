import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  // ------------------------------------------------

  Future<LoginData> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final loginData = prefs.getString("loginData");
    if (loginData != null) {
      Map<String, dynamic> userMap = jsonDecode(loginData);
      return LoginData.fromJson(userMap);
    }
    return LoginData();
  }

  Future<void> storeLoginData(LoginData loginData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "loginData",
      jsonEncode(loginData.toJson()),
    );
  }

  // ------------------------------------------------

  Future<LoginData> userLogin(Map<String, String> reqBody) async {
    final resp = await http.post(
      Uri.http(Constants.domain, "/api/user/login"),
      body: jsonEncode(reqBody),
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body != null) {
        final loginData = LoginData.fromJson(body);
        await storeLoginData(loginData);
        return loginData;
      }
    } else {
      final body = jsonDecode(resp.body);
      if (body != null) {
        final errorResp = LoginData.fromJson(body);
        return errorResp;
      }
    }
    return LoginData();
  }

  Future<UserProfile> fetchProfile() async {
    final loginData = await getLoginData();
    if (loginData.isLoggedIn) {
      final resp = await http.get(
        Uri.http(
          Constants.domain,
          "/api/user/profile",
        ),
        headers: {"Authorization": "Bearer ${loginData.token}"},
      );
      if (resp.statusCode == 200) {
        final respBody = jsonDecode(resp.body);
        if (respBody != null) {
          return UserProfile.fromJson(respBody);
        }
      } else {
        final body = jsonDecode(resp.body);
        if (body != null) {
          final errorResp = LoginData.fromJson(body);
          print(
            "Code : ${errorResp.code} Message: ${errorResp.message} Error: ${errorResp.error}",
          );
        }
        return UserProfile();
      }
    }
    return UserProfile();
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("loginData");
  }

  Future<ErrorResp> registerUser(Map<String, String> reqBody) async {
    final resp = await http.post(
      Uri.http(Constants.domain, "/api/user/register"),
      body: jsonEncode(reqBody),
    );
    if (resp.statusCode == 200) {
      return ErrorResp();
    } else {
      final body = jsonDecode(resp.body);
      if (body != null) {
        final errorResp = ErrorResp.fromJson(body);
        return errorResp;
      }
    }
    return ErrorResp();
  }

  Future<bool> checkUserDisplayName(Map<String, String> reqBody) async {
    bool isNameExisted = true;
    final resp = await http.post(
      Uri.http(Constants.domain, "/user/checkUserDisplayName"),
      body: reqBody,
    );
    if (resp.statusCode == 200) {
      isNameExisted = jsonDecode(resp.body);
    }
    return isNameExisted;
  }

  Future<bool> checkEmail(Map<String, String> reqBody) async {
    bool isNameExisted = true;
    final resp = await http.post(
      Uri.http(Constants.domain, "/user/checkEmail"),
      body: reqBody,
    );
    if (resp.statusCode == 200) {
      isNameExisted = jsonDecode(resp.body);
    }
    return isNameExisted;
  }

  // ------------------------------------------------

  Future<bool> editUser(Map<String, String> reqBody) async {
    final loginData = await getLoginData();
    if (loginData.isLoggedIn) {
      reqBody["userID"] = loginData.user.id.toString();
      reqBody["token"] = loginData.token;

      final resp = await http.post(
        Uri.http(Constants.domain, "/user/editUser"),
        body: reqBody,
      );
      if (resp.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  Future<EditPwResp> editPassword(Map<String, String> reqBody) async {
    final loginData = await getLoginData();
    if (loginData.isLoggedIn) {
      reqBody["userID"] = loginData.user.id.toString();
      reqBody["token"] = loginData.token;

      final resp = await http.post(
        Uri.http(Constants.domain, "/user/editPassword"),
        body: reqBody,
      );
      if (resp.statusCode == 200) {
        return EditPwResp.ok;
      } else if (resp.statusCode == 400 && resp.body == 'oldPasswordWrong') {
        return EditPwResp.oldPasswordWrong;
      } else if (resp.statusCode == 400 && resp.body == 'newPasswordError') {
        return EditPwResp.newPasswordError;
      }
    }
    return EditPwResp.error;
  }

  // ----------------------------------------------------------------
}
