import 'dart:math';

import 'package:how_to/providers/constants.dart';

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
    user = User.fromJson(json['user']);
    token = json['token'] ?? "";
    isLoggedIn = json['token'] != null && json['token'] != "";
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

class ErrorResp {
  int code = 0;
  String message = "";
  String error = "";

  ErrorResp();

  ErrorResp.withParams({
    required this.code,
    required this.message,
    required this.error,
  });

  ErrorResp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? "";
    error = json['error'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'error': error,
    };
  }
}

enum EditPwResp { ok, oldPasswordWrong, newPasswordError, error }

class User {
  String id = "";
  String email = "";
  String password = "";
  String type = "";
  String role = "";
  String status = "";
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  int avatarColorIndex = 0;

  User();

  User.withParams({
    required this.id,
    required this.email,
    required this.password,
    required this.type,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.avatarColorIndex,
  });

  User.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    id = json['id'] ?? "";
    email = json['email'] ?? "";
    type = json['type'] ?? "";
    role = json['role'] ?? "";
    status = json['status'] ?? "";
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
    avatarColorIndex = Random().nextInt(Constants.avatarColorList.length - 1);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'type': type,
      'role': role,
      'status': status,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'avatarColor': avatarColorIndex,
    };
  }
}

class UserProfile {
  String userID = "";
  String displayName = "";
  String name = "";
  DateTime birthDate = DateTime.now();
  String phone = "";
  String imageUrl = "";
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  UserProfile();

  UserProfile.withParams({
    required this.userID,
    required this.displayName,
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  UserProfile.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    userID = json['userID'] ?? "";
    displayName = json['displayName'] ?? "";
    name = json['name'] ?? "";
    birthDate = json['birthDate'] != null
        ? DateTime.parse(json['birthDate'])
        : DateTime.now();
    phone = json['phone'] ?? "";
    imageUrl = json['imageURL'] ?? "";
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now();
    updatedAt = json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'displayName': displayName,
      'name': name,
      'birthDate': birthDate.toString(),
      'phone': phone,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
    };
  }
}
