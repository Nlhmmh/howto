import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
import 'package:http/http.dart' as http;

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
  bool isLoggedIn = false;
  ColorMap avatarColor = Constants.avatarColorList.first;

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
    required this.isLoggedIn,
    required this.avatarColor,
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
    isLoggedIn = true;
    avatarColor = Constants.avatarColorList[
        Random().nextInt(Constants.avatarColorList.length - 1)];
  }
}

class LoginResp {
  User user = User();
  String token = "";

  LoginResp();

  LoginResp.withParams({
    required this.user,
    required this.token,
  });

  LoginResp.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    token = json['token'];
  }
}

class UserProvider with ChangeNotifier {
  User _user = User();
  String _token = "";
  int _userID = 0;

  String get token => _token;
  User get user => _user;
  int get userID => _userID;

  Future<User> fetchUser() async {
    final resp = await http.post(
      Uri.http(Constants.domain, "/user/fetchUser"),
      body: {
        "userID": _userID.toString(),
        "token": token,
      },
    );
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody != null) {
        _user = User.fromJson(respBody);
      }
    }
    return _user;
  }

  Future<User> registerUser(Map<String, String> reqBody) async {
    final resp = await http.post(
      Uri.http(Constants.domain, "/user/registerUser"),
      body: reqBody,
    );
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody != null) {
        final loginResp = LoginResp.fromJson(respBody);
        _user = loginResp.user;
        _userID = _user.id;
        _token = loginResp.token;
      }
    }
    return _user;
  }

  Future<User> loginUser(Map<String, String> reqBody) async {
    final resp = await http.post(
      Uri.http(Constants.domain, "/user/loginUser"),
      body: reqBody,
    );
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody != null) {
        final loginResp = LoginResp.fromJson(respBody);
        _user = loginResp.user;
        _userID = _user.id;
        _token = loginResp.token;
      }
    }
    return _user;
  }

  void logOut() async {
    _user = User();
    _userID = 0;
    _token = "";
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

  Future<bool> editUser(Map<String, String> reqBody) async {
    reqBody["userID"] = _userID.toString();
    reqBody["token"] = _token;

    final resp = await http.post(
      Uri.http(Constants.domain, "/user/editUser"),
      body: reqBody,
    );
    if (resp.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<editPwResp> editPassword(Map<String, String> reqBody) async {
    reqBody["userID"] = _userID.toString();
    reqBody["token"] = _token;

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
    return editPwResp.error;
  }
}

enum editPwResp { ok, oldPasswordWrong, newPasswordError, error }
