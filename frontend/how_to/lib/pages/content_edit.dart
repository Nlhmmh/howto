import 'package:flutter/material.dart';
import 'package:how_to/pages/content_create/image_adder.dart';
import 'package:how_to/pages/content_create/models.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/api/content_ctrls.dart';
import 'package:how_to/providers/api/file_ctrls.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class ContentEditArgs {
  String contentID = "";
  ContentEditArgs({required this.contentID});
}

class ContentEdit extends StatefulWidget {
  static const routeName = "/content/edit";

  const ContentEdit({Key? key}) : super(key: key);

  @override
  State<ContentEdit> createState() => _ContentEditState();
}

class _ContentEditState extends State<ContentEdit> {
  String _contentID = "";
  Content _content = Content();
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  List<ContentCategory> _ctnCatList = [];
  ContentCategory _selCat = ContentCategory();
  final String _errMsg = "";
  final BodyContent _mainImg = BodyContent(
    orderNo: 0,
    mode: BodyContentMode.image,
    widget: Container(),
  );
  final HtmlEditorController _htmlCtrl = HtmlEditorController();
  String _contentHTML = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args =
          ModalRoute.of(context)!.settings.arguments as ContentEditArgs;
      _contentID = args.contentID;

      final ctnCatList = await ContentCtrls.getAllCtnCat((errResp) {
        if (!mounted) return;
        Utils.checkErrorResp(context, errResp);
      });
      _ctnCatList = ctnCatList;
      if (_ctnCatList.isNotEmpty) _selCat = ctnCatList.first;
      setState(() {});

      await _getContent();
    });
  }

  Future<void> _getContent() async {
    final content = await ContentCtrls.get((errResp) {
      if (!mounted) return;
      Utils.checkErrorResp(context, errResp);
    }, contentID: _contentID);
    _content = content;
    _titleCtrl.text = _content.title;
    if (_ctnCatList.isNotEmpty) {
      _selCat = _ctnCatList.firstWhere(
        (v) => v.id == _content.categoryID,
        orElse: () => _ctnCatList.first,
      );
    }
    _mainImg.image = await FileCtrls.getImage(_content.imageUrl);
    _mainImg.imagePath = _content.imageUrl;

    _contentHTML = _content.contentHTML[0].html;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_content.title),
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

                  // --------------- Edit Body
                  InkWell(
                    child: InkWell(
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 5),
                              Text(
                                'Edit Body',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      await _editBodyDialog();
                    },
                  ),
                  const SizedBox(height: 20),

                  if (_errMsg != "") ...[
                    Text(_errMsg),
                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 60),

                  primaryBtn(
                    context: context,
                    text: "Edit",
                    onPressed: () async {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editBodyDialog() async {
    FocusScope.of(context).unfocus();
    await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Edit Body",
        body: Column(
          children: [
            HtmlEditor(
              controller: _htmlCtrl,
              htmlEditorOptions: HtmlEditorOptions(
                initialText: _contentHTML,
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.aboveEditor,
                toolbarType: ToolbarType.nativeGrid,
                gridViewHorizontalSpacing: -10,
                gridViewVerticalSpacing: -10,
                textStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
                toolbarItemHeight: 40,
                buttonBorderColor: Colors.black,
                buttonBorderWidth: 1,
                buttonBorderRadius: BorderRadius.circular(10),
                buttonSelectedColor: Colors.blue,
                defaultToolbarButtons: [
                  const StyleButtons(),
                  const FontButtons(
                    subscript: false,
                    superscript: false,
                  ),
                  const ParagraphButtons(
                    lineHeight: false,
                    caseConverter: false,
                    textDirection: false,
                  ),
                  const ColorButtons(),
                ],
              ),
              otherOptions: const OtherOptions(),
            ),
            const SizedBox(height: 20),
            primaryBtn(
              context: context,
              text: "OK",
              onPressed: () async {
                _contentHTML = await _htmlCtrl.getText();
                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
