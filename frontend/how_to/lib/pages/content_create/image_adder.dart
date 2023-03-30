import 'dart:io';

import 'package:flutter/material.dart';
import 'package:how_to/pages/content_create/models.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImageAdder extends StatefulWidget {
  final BodyContent bdCtn;
  final double height;

  const ImageAdder({
    Key? key,
    required this.bdCtn,
    this.height = 200,
  }) : super(key: key);

  @override
  State<ImageAdder> createState() => _ImageAdderState();
}

class _ImageAdderState extends State<ImageAdder> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (widget.bdCtn.image != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          child: Column(
            children: [
              // --------------- Order No
              if (widget.bdCtn.orderNo != 0) ...[
                Row(
                  children: [
                    const Text('Image'),
                    const SizedBox(width: 5),
                    Text("[ Order : ${widget.bdCtn.orderNo.toString()} ]"),
                  ],
                ),
                const SizedBox(height: 5),
              ],

              // --------------- Image
              SizedBox(
                height: widget.height,
                child: Stack(
                  children: [
                    // --------------- Image
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(widget.bdCtn.image!),
                        ),
                      ),
                    ),
                    // --------------- Delete Btn
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            widget.bdCtn.image = null;
                            setState(() {});
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            // --------------- Order No
            if (widget.bdCtn.orderNo != 0) ...[
              Row(
                children: [
                  const Text('Image'),
                  const SizedBox(width: 5),
                  Text("[ Order : ${widget.bdCtn.orderNo.toString()} ]"),
                ],
              ),
              const SizedBox(height: 5),
            ],

            // --------------- No Image
            SizedBox(
              height: widget.height,
              child: Card(
                elevation: 3,
                child: Stack(
                  children: [
                    // --------------- No Image
                    const Center(child: Text("No Image")),
                    // --------------- Add Btn
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: _onImage,
                          child: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _onImage() async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            // --------------- Title
            const SizedBox(height: 10),
            const Text(
              "Pick Image",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // --------------- Divider
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 20),

            // --------------- Button List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // --------------- Gallery
                iconTextButton(
                  text: "Gallery",
                  icon: Icons.collections,
                  onTap: () async {
                    // Pick an image
                    final pickedImg = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedImg == null) return;
                    widget.bdCtn.image = File(
                      pickedImg.path,
                    );
                    setState(() {});
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                ),
                // --------------- Camera
                iconTextButton(
                  text: "Camera",
                  icon: Icons.camera_alt,
                  onTap: () async {
                    // Capture an image
                    final pickedImg = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedImg == null) return;
                    widget.bdCtn.image = File(
                      pickedImg.path,
                    );
                    setState(() {});
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
