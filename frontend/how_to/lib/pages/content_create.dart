import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:how_to/providers/content_provider.dart';
import 'package:how_to/pages/top.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ContentCreate extends StatefulWidget {
  static const routeName = "/content/create";
  static const routeIndex = 1;

  const ContentCreate({Key? key}) : super(key: key);

  @override
  State<ContentCreate> createState() => _ContentCreateState();
}

enum BodyContentMode { text, image }

class BodyContent {
  int index;
  String text;
  XFile image;
  BodyContentMode mode;

  BodyContent({
    required this.index,
    required this.text,
    required this.image,
    required this.mode,
  });
}

class _ContentCreateState extends State<ContentCreate> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  String _selCategory = "cooking";

  final List<BodyContent> _bodyContentList = [];
  final List<Uint8List> _imageList = [];
  final List<String> _textList = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      _titleCtrl.text = "How to boil potato?";
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------- Title
                const Text("Title"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'How to draw anime',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // -------------------------------- Category
                const Text('Category'),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _selCategory,
                  items: [
                    'cooking',
                    'handcrafts',
                    'education',
                    'knowledge',
                  ].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selCategory = newValue!;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // -------------------------------- Body List
                ..._bodyContentList.map((body) {
                  if (body.mode == BodyContentMode.image) {
                    return ImageAdder(image: body.image);
                  } else {
                    return TextAdder(textList: _textList);
                  }
                }).toList(),
                const SizedBox(height: 20),

                // -------------------------------- New Widget
                InkWell(
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [6],
                    strokeCap: StrokeCap.round,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: Column(
                          children: const [
                            Icon(Icons.add),
                            Text(
                              'Add New Widget',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            // -------------------------------- Title
                            const SizedBox(height: 10),
                            const Text(
                              "Choose Widget",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // -------------------------------- Divider
                            const Divider(height: 1, color: Colors.grey),
                            const SizedBox(height: 20),

                            // -------------------------------- Button List
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // -------------------------------- Text
                                iconTextButton(
                                  text: "Text",
                                  icon: Icons.text_fields,
                                  onTap: () async {
                                    setState(() {
                                      // int index = _bodyContentList.length;
                                      // _bodyContentList.add(
                                      //   BodyContent(
                                      //     index: index,
                                      //     body: BodyContentWidget(
                                      //       body: TextAdder(
                                      //         textList: _textList,
                                      //       ),
                                      //       onDeleteTap: () {
                                      //         setState(() {
                                      //           _bodyContentList.removeWhere(
                                      //               (bodyContent) =>
                                      //                   bodyContent.index ==
                                      //                   index);
                                      //         });
                                      //       },
                                      //     ),
                                      //   ),
                                      // );
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                // -------------------------------- Image
                                iconTextButton(
                                  text: "Image",
                                  icon: Icons.photo,
                                  onTap: () async {
                                    setState(() {
                                      int index = _bodyContentList.length;
                                      Uint8List image =
                                          Uint8List.fromList(List<int>.empty());
                                      _imageList.add(image);
                                      _bodyContentList.add(
                                        BodyContent(
                                          index: index,
                                          mode: BodyContentMode.image,
                                          text: "",
                                          image: XFile(""),
                                          // body: BodyContentWidget(
                                          //   body: ImageAdder(
                                          //     imageList: _imageList,
                                          //   ),
                                          //   onDeleteTap: () {
                                          //     setState(() {
                                          //       _bodyContentList.removeWhere(
                                          //           (bodyContent) =>
                                          //               bodyContent.index ==
                                          //               index);
                                          //     });
                                          //   },
                                          // ),
                                        ),
                                      );
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // -------------------------------- Confirm Btn
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text("Confirm"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final isAdded = await Provider.of<ContentProvider>(
                          context,
                          listen: false,
                        ).createContent({
                          "title": _titleCtrl.text,
                          "category": _selCategory,
                        });
                        if (isAdded) {
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TopPage(),
                            ),
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BodyContentWidget extends StatelessWidget {
  final Widget body;
  final Function() onDeleteTap;

  const BodyContentWidget({
    Key? key,
    required this.body,
    required this.onDeleteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: body),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          child: iconTextButton(
            text: "Remove Widget",
            icon: Icons.delete,
            iconSize: 25,
            textSize: 12,
            onTap: onDeleteTap,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            border: Border.all(),
          ),
        ),
      ],
    );
  }
}

class ImageAdder extends StatefulWidget {
  final XFile image;

  const ImageAdder({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ImageAdder> createState() => _ImageAdderState();
}

class _ImageAdderState extends State<ImageAdder> {
  String _imgPath = "";

  @override
  Widget build(BuildContext context) {
    if (_imgPath != "") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Card(
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(_imgPath),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: const Icon(Icons.delete),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: () {
                        // widget.imageList
                        //     .removeWhere((image) => image.path == _imgPath);
                        setState(() {
                          _imgPath = "";
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 200,
        child: Card(
          elevation: 3,
          child: Stack(
            children: [
              const Center(
                child: Text(
                  "No Image",
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    child: const Icon(Icons.add_a_photo),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => SizedBox(
                          height: 150,
                          child: Column(
                            children: [
                              // -------------------------------- Title
                              const SizedBox(height: 10),
                              const Text(
                                "Pick Image",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // -------------------------------- Divider
                              const Divider(height: 1, color: Colors.grey),
                              const SizedBox(height: 20),

                              // -------------------------------- Button List
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // -------------------------------- Gallery
                                  iconTextButton(
                                    text: "Gallery",
                                    icon: Icons.collections,
                                    onTap: () async {
                                      // Pick an image
                                      final XFile? pickedImg =
                                          await _picker.pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedImg != null) {
                                        // widget.imageList.add(pickedImg);
                                        setState(() {
                                          _imgPath = pickedImg.path;
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                  // -------------------------------- Camera
                                  iconTextButton(
                                    text: "Camera",
                                    icon: Icons.camera_alt,
                                    onTap: () async {
                                      // Capture a photo
                                      final XFile? pickedImg =
                                          await _picker.pickImage(
                                              source: ImageSource.camera);
                                      if (pickedImg != null) {
                                        // widget.imageList.add(pickedImg);
                                        setState(() {
                                          _imgPath = pickedImg.path;
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TextAdder extends StatefulWidget {
  final List<String> textList;

  const TextAdder({
    Key? key,
    required this.textList,
  }) : super(key: key);

  @override
  State<TextAdder> createState() => _TextAdderState();
}

class _TextAdderState extends State<TextAdder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 110,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text'),
            const SizedBox(height: 5),
            TextFormField(
              minLines: 2,
              maxLines: 1000,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                widget.textList.add(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
