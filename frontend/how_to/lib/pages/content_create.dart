import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:how_to/pages/bottom_navi.dart';
import 'package:how_to/pages/content_create/body_content.dart';
import 'package:how_to/pages/content_create/html.dart';
import 'package:how_to/pages/content_create/image_adder.dart';
import 'package:how_to/pages/content_create/models.dart';
import 'package:how_to/pages/content_create/text_adder.dart';
import 'package:how_to/providers/api/content_ctrls.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/api/file_ctrls.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';

class ContentCreate extends StatefulWidget {
  static const routeName = "/content/create";

  const ContentCreate({Key? key}) : super(key: key);

  @override
  State<ContentCreate> createState() => _ContentCreateState();
}

class _ContentCreateState extends State<ContentCreate> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  List<ContentCategory> _ctnCatList = [];
  ContentCategory _selCat = ContentCategory();
  final List<BodyContent> _bdCtnList = [];
  int _orderNo = 0;
  String _errMsg = "";
  final BodyContent _mainImg = BodyContent(
    orderNo: 0,
    mode: BodyContentMode.image,
    widget: Container(),
  );

  @override
  void initState() {
    super.initState();
    _titleCtrl.text = "How to boil potato?";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ctnCatList = await ContentCtrls.getAllCtnCat((errResp) {
        if (!mounted) return;
        Utils.checkErrorResp(context, errResp);
      });
      _ctnCatList = ctnCatList;
      if (_ctnCatList.isNotEmpty) _selCat = ctnCatList.first;
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add New Content'),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   child: primaryBtn(
      //     context: context,
      //     text: "Confirm",
      //     onPressed: () async {
      //       await _onConfirm();
      //     },
      //   ),
      // ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 10),
            primaryBtn(
              context: context,
              text: "Confirm",
              onPressed: () async {
                await _onConfirm();
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --------------- Title
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
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (v.length > 30) {
                        return 'Title must be less than 30';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // --------------- Category
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
                    items: _ctnCatList.map((v) {
                      return DropdownMenuItem<ContentCategory>(
                        value: v,
                        child: Text(v.name),
                      );
                    }).toList(),
                    onChanged: (ContentCategory? newV) {
                      _selCat = newV!;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null) return 'Required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // --------------- Main Image
                  const Text("Main Image"),
                  const SizedBox(height: 5),
                  ImageAdder(
                    bdCtn: _mainImg,
                    height: 300,
                  ),
                  const SizedBox(height: 10),

                  // --------------- Body List
                  ..._bdCtnList.map((v) => v.widget).toList(),
                  const SizedBox(height: 20),

                  // --------------- Add New Widget
                  InkWell(
                    child: InkWell(
                      // DottedBorder(
                      // borderType: BorderType.RRect,
                      // radius: const Radius.circular(12),
                      // dashPattern: const [6],
                      // strokeCap: StrokeCap.round,
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                      await _bdCtnDialog();
                    },
                  ),
                  const SizedBox(height: 20),

                  if (_errMsg != "") ...[
                    Text(_errMsg),
                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onConfirm() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      try {
        // Check Main Image
        if (_mainImg.image == null) {
          _errMsg = "Main image is empty";
          setState(() {});
          return;
        }

        // Check Null Image, Null Text
        for (final bc in _bdCtnList) {
          if (bc.mode == BodyContentMode.image && bc.image == null) {
            _errMsg = "Image at Order [ ${bc.orderNo} ] is empty";
            setState(() {});
            return;
          }
          if (bc.mode == BodyContentMode.text && bc.text == "") {
            _errMsg = "Text at Order [ ${bc.orderNo} ] is empty";
            setState(() {});
            return;
          }
        }

        // Open Confirm Dialog
        await showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: "Confirm",
            body: Column(
              children: [
                Html(
                  data: HTMLBuilder.build(
                    title: _titleCtrl.text,
                    category: _selCat.name,
                    mainImg: _mainImg,
                    bdCtnList: _bdCtnList,
                  ),
                  style: {
                    "p": Style(whiteSpace: WhiteSpace.PRE),
                  },
                ),
                const SizedBox(height: 20),
                primaryBtn(
                  context: context,
                  text: "Create Content",
                  onPressed: () async {
                    // Uploade Image
                    final mainImgResp = await FileCtrls.upload(_mainImg.image!);
                    if (mainImgResp.errResp.code != 0) {
                      if (!mounted) return;
                      Utils.checkErrorResp(context, mainImgResp.errResp);
                      return;
                    }

                    for (final bc in _bdCtnList) {
                      if (bc.mode == BodyContentMode.image) {
                        // Uploade Image
                        final imgResp = await FileCtrls.upload(bc.image!);
                        if (imgResp.errResp.code != 0) {
                          if (!mounted) return;
                          Utils.checkErrorResp(context, imgResp.errResp);
                        }
                        bc.imagePath = imgResp.filePath;
                      }
                    }

                    final finalHTML = HTMLBuilder.buildFinal(
                      title: _titleCtrl.text,
                      category: _selCat.name,
                      bdCtnList: _bdCtnList,
                    );

                    // Create Content
                    final errResp = await ContentCtrls.create({
                      "title": _titleCtrl.text,
                      "categoryID": _selCat.id,
                      "imageUrl": mainImgResp.filePath,
                      "contentHTMLList": [
                        {
                          "orderNo": 1,
                          "html": finalHTML,
                        }
                      ],
                      // "contentHTMLList": _bdCtnList.map((e) {
                      //   return {
                      //     "orderNo": 1,
                      //     "html": finalHTML,
                      //   };
                      // }).toList(),
                    });
                    if (errResp.code != 0) {
                      if (!mounted) return;
                      Utils.checkErrorResp(context, errResp);
                      return;
                    }
                    if (!mounted) return;
                    await Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BottomNaviPage(
                          pageIndex: 0,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      } catch (e, stack) {
        print(e);
        print(stack);
      }
    }
  }

  Future<void> _bdCtnDialog() async {
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
              "Choose Widget",
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
                // --------------- Text
                iconTextButton(
                  text: "Text",
                  icon: Icons.text_fields,
                  onTap: () async {
                    _orderNo = _orderNo + 1;
                    final tmpOrderNo = _orderNo;
                    final tmpBdCtn = BodyContent(
                      orderNo: tmpOrderNo,
                      mode: BodyContentMode.text,
                      widget: Container(),
                    );
                    tmpBdCtn.widget = BdCtnWidget(
                      body: TextAdder(bdCtn: tmpBdCtn),
                      onDelTap: () {
                        _bdCtnList.removeWhere((v) => v.orderNo == tmpOrderNo);
                        setState(() {});
                      },
                    );
                    _bdCtnList.add(tmpBdCtn);
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
                // --------------- Image
                iconTextButton(
                  text: "Image",
                  icon: Icons.photo,
                  onTap: () async {
                    _orderNo = _orderNo + 1;
                    final tmpOrderNo = _orderNo;
                    final tmpBdCtn = BodyContent(
                      orderNo: tmpOrderNo,
                      mode: BodyContentMode.image,
                      widget: Container(),
                    );
                    tmpBdCtn.widget = BdCtnWidget(
                      body: ImageAdder(bdCtn: tmpBdCtn),
                      onDelTap: () {
                        _bdCtnList.removeWhere((v) => v.orderNo == tmpOrderNo);
                        setState(() {});
                      },
                    );
                    _bdCtnList.add(tmpBdCtn);
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
  }
}
