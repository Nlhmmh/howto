import 'package:flutter/material.dart';
import 'package:how_to/components/content_card.dart';
import 'package:how_to/providers/api/content_ctrls.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';

class TopPage extends StatefulWidget {
  static const routeName = "/top";
  static const routeIndex = 0;

  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<Content> _contentList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final contentList = await ContentCtrls.list((errResp) {
        if (!mounted) return;
        Utils.checkErrorResp(context, errResp);
      });
      _contentList = contentList;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) => GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _contentList.length,
            itemBuilder: (BuildContext context, int index) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              // --------------- Content Card
              child: ContentCard(content: _contentList[index]),
            ),
          ),
        ),
      ),
    );
  }
}
