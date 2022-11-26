import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
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
      jsonEncode(
        loginData.toJson(),
      ),
    );
  }

  // ------------------------------------------------

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

  Future<LoginData> loginUser(Map<String, String> reqBody) async {
    final resp = await http.post(
      Uri.http(Constants.domain, "/user/loginUser"),
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

  Future<editPwResp> editPassword(Map<String, String> reqBody) async {
    final loginData = await getLoginData();
    if (loginData.isLoggedIn) {
      reqBody["userID"] = loginData.user.id.toString();
      reqBody["token"] = loginData.token;

      final resp = await http.post(
        Uri.http(Constants.domain, "/user/editPassword"),
        body: reqBody,
      );
      if (resp.statusCode == 200) {
        return editPwResp.ok;
      } else if (resp.statusCode == 400 && resp.body == 'oldPasswordWrong') {
        return editPwResp.oldPasswordWrong;
      } else if (resp.statusCode == 400 && resp.body == 'newPasswordError') {
        return editPwResp.newPasswordError;
      }
    }
    return editPwResp.error;
  }
}

// ----------------------------------------------------------------

enum editPwResp { ok, oldPasswordWrong, newPasswordError, error }

class User {
  int id = 0;
  String displayName = "";
  String name = "";
  DateTime birthDate = DateTime.now();
  String phone = "";
  String email = "";
  String password = "";
  bool isAdmin = false;
  String accountType = "";
  String accountStatus = "";
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  int avatarColorIndex = 0;

  User();

  User.withParams({
    required this.id,
    required this.displayName,
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.accountType,
    required this.accountStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.avatarColorIndex,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    name = json['name'];
    birthDate = DateTime.parse(json['birthDate']);
    phone = json['phone'] ?? "";
    email = json['email'];
    isAdmin = json['isAdmin'] ?? false;
    accountType = json['accountType'];
    accountStatus = json['accountStatus'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    avatarColorIndex = Random().nextInt(Constants.avatarColorList.length - 1);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'name': name,
      'birthDate': birthDate.toString(),
      'phone': phone,
      'email': email,
      'isAdmin': isAdmin,
      'accountType': accountType,
      'accountStatus': accountStatus,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'avatarColor': avatarColorIndex,
    };
  }
}

class LoginData {
  User user = User();
  bool isLoggedIn = false;
  String token = "";

  LoginData();

  LoginData.withParams({
    required this.user,
    required this.token,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    token = json['token'];
    isLoggedIn = true;
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'isLoggedIn': isLoggedIn,
      'token': token,
    };
  }
}
