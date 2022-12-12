import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImgPick extends StatefulWidget {
  final void Function() imageUpload;

  const ImgPick({
    super.key,
    required this.imageUpload,
  });

  @override
  State<ImgPick> createState() => _ImgPickState();
}

class _ImgPickState extends State<ImgPick> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future _pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      _image = File(image.path);
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: CircleAvatar(
            maxRadius: 25,
            child: ClipOval(
              child: _image != null
                  ? Image.file(
                      _image!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, size: 25),
            ),
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: SizedBox(
            width: 25,
            height: 25,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
              ),
              child: const Icon(Icons.edit, size: 16),
              onPressed: () async {
                await _pickImage();
              },
            ),
          ),
        ),
      ],
    );
  }
}
