import 'dart:io';

import 'package:flutter/cupertino.dart';

enum BodyContentMode { text, image }

class BodyContent {
  int orderNo;
  BodyContentMode mode;
  Widget widget;
  String text = "";
  File? image;
  String imagePath;

  BodyContent({
    required this.orderNo,
    required this.mode,
    required this.widget,
    this.text = "",
    this.image,
    this.imagePath = "",
  });
}
