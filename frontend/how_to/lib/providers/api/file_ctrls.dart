import 'dart:convert';
import 'dart:io';

import 'package:how_to/providers/api/api.dart';
import 'package:how_to/providers/models.dart';

abstract class FileCtrls {
  static Future<UploadFile> upload(File file) async {
    final resp = await API.postMultipart(
      path: "/api/file/upload",
      file: file,
    );
    final respBody = await resp.stream.bytesToString();
    return UploadFile.fromJson(jsonDecode(respBody));
  }
}
