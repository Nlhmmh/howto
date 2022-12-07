import 'package:flutter/material.dart';
import 'package:frontend/pages/content_create.dart';
import 'package:frontend/pages/mypage.dart';
import 'package:frontend/pages/test.dart';
import 'package:frontend/pages/top.dart';
import 'package:frontend/providers/constants.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/providers/models.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BottomNaviPage extends StatefulWidget {
  static const routeName = "/bottomnavi";

  final int pageIndex;

  const BottomNaviPage({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);

  @override
  State<BottomNaviPage> createState() => _BottomNaviPageState();
}

class _BottomNaviPageState extends State<BottomNaviPage> {
  final _pageCtrl = PageController();
  int _selIndex = 0;

  LoginData _loginData = LoginData();

  @override
  void initState() {
    super.initState();

    setState(() {
      _selIndex = widget.pageIndex;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginData = await Provider.of<UserProvider>(context, listen: false)
          .getLoginData();
      setState(() {
        _loginData = loginData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("How To"),
                Text(
                  "Good Morning! ${_loginData.isLoggedIn ? _loginData.user.email : ""}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageCtrl,
        children: const [
          TopPage(),
          ContentCreate(),
          MyPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            _selIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selIndex,
        onTap: (index) {
          _pageCtrl.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items: _loginData.user.accountType == Constants.creatorAccType
            ? const [
                // -------------------------------- Home
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                // -------------------------------- Create Content
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined),
                  label: 'Create Content',
                ),
                // -------------------------------- My Page
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
                  label: 'My Page',
                ),
              ]
            : const [
                // -------------------------------- Home
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                // -------------------------------- Favourite
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favourite',
                ),
                // -------------------------------- My Page
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
                  label: 'My Page',
                ),
              ],
        enableFeedback: true,
      ),
    );
  }
}
