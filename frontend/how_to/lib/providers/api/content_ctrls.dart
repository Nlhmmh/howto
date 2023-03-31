import 'dart:convert';

import 'package:how_to/providers/api/api.dart';
import 'package:how_to/providers/models.dart';

abstract class ContentCtrls {
  static Future<List<Content>> fetchContent(
    Function(ErrorResp) cbFunc, {
    Map<String, dynamic>? params,
  }) async {
    final resp = await API.get(
      path: "/api/content/all",
      params: params,
    );
    final respBody = jsonDecode(resp.body);
    final errResp = ErrorResp.fromJson(respBody);
    cbFunc(errResp);
    final tmp = Content.toList(respBody);
    return tmp;
  }

  static Future<ErrorResp> createCtn(Map<String, dynamic> reqBody) async {
    final resp = await API.post(
      path: "/api/content/create",
      body: reqBody,
    );
    return ErrorResp.fromJson(jsonDecode(resp.body));
  }

  static Future<List<ContentCategory>> getAllCtnCat(
    Function(ErrorResp) cbFunc,
  ) async {
    final resp = await API.get(
      path: "/api/content/categories",
    );
    final respBody = jsonDecode(resp.body);
    final errResp = ErrorResp.fromJson(respBody);
    cbFunc(errResp);
    final tmp = ContentCategory.toList(respBody);
    return tmp;
  }
}
