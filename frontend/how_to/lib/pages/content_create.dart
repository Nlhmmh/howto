import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:how_to/providers/content_provider.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ContentCreate extends StatefulWidget {
  static const routeName = "/content/create";

  const ContentCreate({Key? key}) : super(key: key);

  @override
  State<ContentCreate> createState() => _ContentCreateState();
}

enum BodyContentMode { text, image }

class BodyContent {
  int index;
  BodyContentMode mode;
  Widget widget;
  String? text;
  File? image;

  BodyContent(
      {required this.index,
      required this.mode,
      required this.widget,
      this.text,
      this.image});
}

class _ContentCreateState extends State<ContentCreate> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  ContentCategory _selCat = ContentCategory();

  final List<BodyContent> _bodyContentList = [];
  final List<File> _imageList = [];
  final List<String> _textList = [];
  List<ContentCategory> _contentCatList = [];

  final int orderNo = 0;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = "How to boil potato?";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final contentCategoryList = await Provider.of<ContentProvider>(
        context,
        listen: false,
      ).getAllContentCategories();
      _contentCatList = contentCategoryList;
      if (_contentCatList.isNotEmpty) {
        _selCat = _contentCatList.first;
      }
      setState(() {});
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
                  maxLength: 30,
                  decoration: const InputDecoration(
                    isDense: true,
                    // labelText: "Title",
                    // labelStyle: TextStyle(fontSize: 16),
                    hintText: 'How to draw anime',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value.length > 30) {
                      return 'Title must be less than 30';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // -------------------------------- Category
                const Text('Category'),
                const SizedBox(height: 5),
                DropdownButtonFormField<ContentCategory>(
                  value: _selCat,
                  decoration: const InputDecoration(
                    isDense: true,
                    // labelText: "Category",
                    // labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(),
                  ),
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  items: _contentCatList.map((value) {
                    return DropdownMenuItem<ContentCategory>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                  onChanged: (ContentCategory? newValue) {
                    setState(() {
                      _selCat = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // -------------------------------- Body List
                ..._bodyContentList.map((body) {
                  return body.widget;
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
                      height: 100,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add),
                            SizedBox(height: 5),
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
                                    int index = _bodyContentList.length;
                                    _bodyContentList.add(
                                      BodyContent(
                                        index: index,
                                        mode: BodyContentMode.image,
                                        widget: Container(),
                                      ),
                                    );
                                    _bodyContentList.last.text = "";
                                    _bodyContentList.last.widget =
                                        BodyContentWidget(
                                      body: _textAdder(
                                        bodyContent: _bodyContentList.last,
                                      ),
                                      onDeleteTap: () {
                                        _bodyContentList.removeWhere(
                                          (bodyContent) =>
                                              bodyContent.index == index,
                                        );
                                        setState(() {});
                                      },
                                    );
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                ),
                                // -------------------------------- Image
                                iconTextButton(
                                  text: "Image",
                                  icon: Icons.photo,
                                  onTap: () async {
                                    int index = _bodyContentList.length;
                                    _bodyContentList.add(
                                      BodyContent(
                                        index: index,
                                        mode: BodyContentMode.image,
                                        widget: Container(),
                                      ),
                                    );
                                    _bodyContentList.last.widget =
                                        BodyContentWidget(
                                      body: _imageAdder(
                                        bodyContent: _bodyContentList.last,
                                      ),
                                      onDeleteTap: () {
                                        _bodyContentList.removeWhere(
                                          (bodyContent) =>
                                              bodyContent.index == index,
                                        );
                                        setState(() {});
                                      },
                                    );
                                    setState(() {});
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

                const SizedBox(height: 20),

                primaryBtn(
                  context: context,
                  text: "Confirm",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // final isAdded = await Provider.of<ContentProvider>(
                      //   context,
                      //   listen: false,
                      // ).createContent({
                      //   "title": _titleCtrl.text,
                      //   "category": _selCategory,
                      // });
                      // if (isAdded) {
                      //   await Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const TopPage(),
                      //     ),
                      //     (route) => false,
                      //   );
                      // }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textAdder({required BodyContent bodyContent}) {
    return SizedBox(
      width: 200,
      height: 110,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Text'),
                const SizedBox(width: 5),
                Text("[ Order : ${bodyContent.index.toString()} ]"),
              ],
            ),
            const SizedBox(height: 5),
            TextFormField(
              minLines: 2,
              maxLines: 1000,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                bodyContent.text = value;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageAdder({required BodyContent bodyContent}) {
    return Column(
      children: [
        if (bodyContent.image != null) ...[
          Padding(
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
                          image: FileImage(bodyContent.image!),
                        ),
                      ),
                    ),
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
                            bodyContent.image = null;
                            setState(() {});
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ] else ...[
          Padding(
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
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10),
                          ),
                          onPressed: () async {
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
                                    const Divider(
                                        height: 1, color: Colors.grey),
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
                                            final pickedImg =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (pickedImg == null) return;
                                            bodyContent.image =
                                                File(pickedImg.path);
                                            setState(() {});
                                            if (!mounted) return;
                                            Navigator.pop(context);
                                          },
                                        ),
                                        // -------------------------------- Camera
                                        iconTextButton(
                                          text: "Camera",
                                          icon: Icons.camera_alt,
                                          onTap: () async {
                                            // Capture an image
                                            final pickedImg =
                                                await _picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (pickedImg == null) return;
                                            bodyContent.image =
                                                File(pickedImg.path);
                                            print(bodyContent.image!.path);
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
                          },
                          child: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ],
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
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            border: Border.all(),
          ),
          child: iconTextButton(
            text: "Remove Widget",
            icon: Icons.delete,
            iconSize: 25,
            textSize: 12,
            onTap: onDeleteTap,
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
