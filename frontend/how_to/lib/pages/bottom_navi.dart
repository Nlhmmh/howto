import 'package:flutter/material.dart';
import 'package:how_to/pages/content_create.dart';
import 'package:how_to/pages/my_page.dart';
import 'package:how_to/pages/top.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/user_provider.dart';
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
  final _pageCtrl = PageController(initialPage: 0);
  int _selIndex = 0;

  LoginData _loginData = LoginData();

  @override
  void initState() {
    super.initState();

    // Future.delayed(Duration.zero, () async {});
    // WidgetsBinding.instance.addPostFrameCallback((_) async {});

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _selIndex = widget.pageIndex;
      _pageCtrl.animateToPage(
        widget.pageIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
      setState(() {});

      final loginData = await Provider.of<UserProvider>(context, listen: false)
          .getLoginData();
      _loginData = loginData;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // --------------- Avatar
            // CircleAvatar(
            //   backgroundColor: _loginData.isLoggedIn
            //       ? Constants
            //           .avatarColorList[_loginData.user.avatarColorIndex].color
            //       : Colors.white,
            //   child: _loginData.isLoggedIn
            //       ? Text(
            //           _loginData.user.displayName.characters.first
            //               .toUpperCase(),
            //           style: const TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 25,
            //           ),
            //         )
            //       : const Icon(Icons.person),
            // ),
            // const SizedBox(width: 10),

            // --------------- Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("How To"),
                Text(
                  "Good Morning !",
                  style: TextStyle(
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
        physics: const NeverScrollableScrollPhysics(),
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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondaryContainer,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        enableFeedback: true,
        items: _loginData.user.type == Constants.creatorAccType
            ? const [
                // --------------- Home
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                // --------------- Create Content
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined),
                  label: 'Create Content',
                ),
                // --------------- My Page
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
                  label: 'My Page',
                ),
              ]
            : const [
                // --------------- Home
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                // --------------- Favourite
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favourite',
                ),
                // --------------- My Page
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box),
                  label: 'My Page',
                ),
              ],
        onTap: (index) {
          // --------------- Animate To Page
          _pageCtrl.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
      ),
    );
  }
}
