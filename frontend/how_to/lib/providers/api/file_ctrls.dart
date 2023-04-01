import 'dart:convert';
import 'dart:io';

import 'package:how_to/providers/api/api.dart';
import 'package:how_to/providers/models.dart';
import 'package:path_provider/path_provider.dart';

abstract class FileCtrls {
  static Future<File> getImage(String filePath) async {
    final resp = await API.get(
      path: filePath,
    );
    final dir = await getApplicationDocumentsDirectory();
    return File(
      '${dir.path}${filePath.replaceAll("/api/file/media", "")}',
    ).writeAsBytes(
      resp.bodyBytes.buffer.asUint8List(),
    );
  }

  static Future<UploadFile> upload(File file) async {
    final resp = await API.postMultipart(
      path: "/api/file/upload",
      file: file,
    );
    final respBody = await resp.stream.bytesToString();
    return UploadFile.fromJson(jsonDecode(respBody));
  }
}
