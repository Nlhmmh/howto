import 'package:flutter/material.dart';
import 'package:how_to/components/content_card.dart';
import 'package:how_to/pages/content_edit.dart';
import 'package:how_to/providers/api/content_ctrls.dart';
import 'package:how_to/providers/api/user_ctrls.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';

class MyContentsPage extends StatefulWidget {
  static const routeName = "/my/contents";

  const MyContentsPage({Key? key}) : super(key: key);

  @override
  State<MyContentsPage> createState() => _MyContentsPageState();
}

class _MyContentsPageState extends State<MyContentsPage> {
  LoginData _loginData = LoginData();
  List<Content> _myCtnList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginData = await UserCtrls.getLoginData();
      _loginData = loginData;
      setState(() {});

      await _fetchContent();
    });
  }

  Future<void> _fetchContent() async {
    final myCtnList = await ContentCtrls.list(
      (errResp) {
        if (!mounted) return;
        Utils.checkErrorResp(context, errResp);
      },
      params: {
        "searchUserID": _loginData.user.id,
      },
    );
    _myCtnList = myCtnList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Contents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.6,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: _myCtnList.length,
            itemBuilder: (BuildContext context, int index) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              // --------------- Content Card
              child: Stack(
                children: [
                  ContentCard(content: _myCtnList[index]),
                  Positioned(
                    top: 10,
                    right: 40,
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
                          await Navigator.pushNamed(
                            context,
                            ContentEdit.routeName,
                            arguments: ContentEditArgs(
                              contentID: _myCtnList[index].id,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(0),
                          backgroundColor: Colors.red,
                        ),
                        child: const Icon(Icons.delete, size: 16),
                        onPressed: () async {
                          final resp = await ContentCtrls.delete({
                            "contentID": _myCtnList[index].id,
                          });
                          if (resp.code != 0) {
                            if (!mounted) return;
                            Utils.checkErrorResp(context, resp);
                            return;
                          }
                          await _fetchContent();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
