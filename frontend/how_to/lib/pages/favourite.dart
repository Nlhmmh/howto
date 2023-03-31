import 'package:flutter/material.dart';
import 'package:how_to/components/content_card.dart';
import 'package:how_to/providers/api/user_ctrls.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';

class FavouritePage extends StatefulWidget {
  static const routeName = "/favourite";

  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  LoginData _loginData = LoginData();
  List<Content> _ctnList = [];
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
    final myCtnList = await UserCtrls.favList(
      (errResp) {
        if (!mounted) return;
        Utils.checkErrorResp(context, errResp);
      },
      params: {},
    );
    _ctnList = myCtnList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Favourites'),
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
            itemCount: _ctnList.length,
            itemBuilder: (BuildContext context, int index) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              // --------------- Content Card
              child: Stack(
                children: [
                  ContentCard(
                    content: _ctnList[index],
                    afterScreen: () async {
                      await _fetchContent();
                    },
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
