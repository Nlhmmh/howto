import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:http/http.dart' as http;

class Content {
  int id = 0;
  int userID = 0;
  String title = "";
  String category = "";
  int viewCount = 0;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  String userName = "";

  Content();

  Content.withParams({
    required this.id,
    required this.userID,
    required this.title,
    required this.category,
    required this.viewCount,
    required this.userName,
  });

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    title = json['title'];
    category = json['category'];
    viewCount = json['viewCount'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    userName = json['userName'];
  }
}

class ContentProvider with ChangeNotifier {
  List<Content> _contentList = [];

  Future<List<Content>> fetchContent() async {
    final resp = await http.get(
      Uri.http(Constants.domain, "/content/fetchAllContents"),
    );
    if (resp.statusCode == 200) {
      final respBody = jsonDecode(resp.body);
      if (respBody != null && respBody.length > 0) {
        _contentList = respBody
            .map<Content>(
              (item) => Content.fromJson(item),
            )
            .toList();
      }
    }
    return _contentList;
  }

  Future<bool> createContent(Map<String, String> reqBody) async {
    final loginData = await UserProvider().getLoginData();
    if (loginData.isLoggedIn) {
      reqBody["userID"] = loginData.user.id.toString();
      reqBody["token"] = loginData.token;
      final resp = await http.post(
        Uri.http(Constants.domain, "/content/createContent"),
        body: reqBody,
      );
      if (resp.statusCode == 200) return true;
    }
    return false;
  }
}
