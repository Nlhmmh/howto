import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/content_create.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/mypage.dart';
import 'package:provider/provider.dart';

// --------------------  --------------------

class CustomDialog extends StatelessWidget {
  final String title;
  final Widget body;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      titlePadding: const EdgeInsets.all(0),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[400],
          )
        ],
      ),
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: body,
          ),
        ),
      ],
    );
  }
}

// --------------------  --------------------

class BottomNavi extends StatefulWidget {
  final int selIndex;

  const BottomNavi({
    Key? key,
    required this.selIndex,
  }) : super(key: key);

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  LoginData _loginData = LoginData();

  @override
  void initState() {
    super.initState();
    Future(() async {
      final loginData = await Provider.of<UserProvider>(context, listen: false)
          .getLoginData();
      setState(() {
        _loginData = loginData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: widget.selIndex,
      onTap: (int index) {
        switch (index) {
          // -------------------------------- Home
          case HomePage.routeIndex:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
            break;
          // -------------------------------- Create Content
          case ContentCreate.routeIndex:
            if (_loginData.isLoggedIn &&
                _loginData.user.accountType == Constants.creatorAccType) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContentCreate(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushNamed(context, Login.routeName);
            }
            break;
          // -------------------------------- My Page
          case MyPage.routeIndex:
            if (_loginData.isLoggedIn) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyPage(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushNamed(context, Login.routeName);
            }
            break;
          default:
            break;
        }
      },
    );
  }
}

// --------------------  --------------------