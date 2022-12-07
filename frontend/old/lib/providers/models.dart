import 'dart:math';

import 'package:frontend/providers/constants.dart';

class LoginData {
  User user = User();
  bool isLoggedIn = false;
  String token = "";
  int code = 0;
  String message = "";
  String error = "";

  LoginData();

  LoginData.withParams({
    required this.user,
    required this.token,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user'] ?? null);
    token = json['token'] ?? "";
    isLoggedIn = false;
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    error = json['error'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'isLoggedIn': isLoggedIn,
      'token': token,
      'code': code,
      'message': message,
      'error': error,
    };
  }
}

// class ErrorResp {
//   int code = 0;
//   String message = "";
//   String error = "";

//   ErrorResp();

//   ErrorResp.withParams({
//     required this.code,
//     required this.message,
//     required this.error,
//   });

//   ErrorResp.fromJson(Map<String, dynamic> json) {
//     code = json['code'] ?? 0;
//     message = json['message'] ?? "";
//     error = json['error'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'code': code,
//       'message': message,
//       'error': error,
//     };
//   }
// }

enum EditPwResp { ok, oldPasswordWrong, newPasswordError, error }

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

  User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
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
