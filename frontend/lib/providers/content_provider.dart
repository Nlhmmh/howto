import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
import 'package:http/http.dart' as http;

class Content {
  int id = 0;
  int userID = 0;
  String title = "";
  String category = "";
  int viewCount = 0;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Content();

  Content.withParams({
    required this.id,
    required this.userID,
    required this.title,
    required this.category,
    required this.viewCount,
  });

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    title = json['title'];
    category = json['category'];
    viewCount = json['viewCount'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
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
}
