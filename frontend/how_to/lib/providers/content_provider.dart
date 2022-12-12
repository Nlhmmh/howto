import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/user_provider.dart';
import 'package:http/http.dart' as http;

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

  Future<List<ContentCategory>> getAllContentCategories() async {
    final resp = await http.get(
      Uri.http(Constants.domain, "/api/content/categories"),
    );
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      if (body != null) {
        final resp = ContentCategory.fromList(body);
        return resp;
      }
    }
    return [];
  }
}
