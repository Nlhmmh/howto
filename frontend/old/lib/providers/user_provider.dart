import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
import 'package:frontend/providers/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
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
      body: reqBody,
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body != null) {
        final loginData = LoginData.fromJson(body);
        loginData.isLoggedIn = true;
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

  Future<LoginData> registerUser(Map<String, String> reqBody) async {
    final resp = await http.post(
      Uri.http(Constants.domain, "/user/registerUser"),
      body: reqBody,
    );
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody != null) {
        final loginData = LoginData.fromJson(respBody);
        await storeLoginData(loginData);
        return loginData;
      }
    }
    return LoginData();
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

  Future<User> fetchUser() async {
    final loginData = await getLoginData();
    if (loginData.isLoggedIn) {
      Map<String, String> reqBody = {};
      reqBody["userID"] = loginData.user.id.toString();
      reqBody["token"] = loginData.token;

      final resp = await http.post(
        Uri.http(Constants.domain, "/user/fetchUser"),
        body: reqBody,
      );
      if (resp.statusCode == 200) {
        final respBody = jsonDecode(resp.body);
        if (respBody != null) {
          loginData.user = User.fromJson(respBody);
          await storeLoginData(loginData);
        }
      }
      return loginData.user;
    }
    return User();
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("loginData");
  }

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
}

// ----------------------------------------------------------------

