import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/widgets.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  static const routeName = "/mypage";
  static const routeIndex = 2;

  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
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
    return Scaffold(
      bottomNavigationBar: const BottomNavi(
        selIndex: MyPage.routeIndex,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              maxRadius: 30,
              backgroundColor: _loginData.isLoggedIn
                  ? Constants
                      .avatarColorList[_loginData.user.avatarColorIndex].color
                  : Colors.white,
              child: _loginData.isLoggedIn
                  ? Text(
                      _loginData.user.displayName.characters.first
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    )
                  : const Icon(Icons.person),
            ),
            const SizedBox(height: 10),
            Text(
              _loginData.user.accountType,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // -------------------------------- Profile
                IconTextButton(
                  text: "Profile",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, Profile.routeName);
                  },
                ),
                // -------------------------------- Favourite
                IconTextButton(
                  text: "Favourite",
                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.pushNamed(context, Profile.routeName);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // -------------------------------- Content List
                if (_loginData.user.accountType == Constants.creatorAccType)
                  IconTextButton(
                    text: "Content List",
                    icon: Icons.newspaper,
                    onTap: () {
                      Navigator.pushNamed(context, Profile.routeName);
                    },
                  ),
                // -------------------------------- Bank
                if (_loginData.user.accountType == Constants.creatorAccType)
                  IconTextButton(
                    text: "Bank",
                    icon: Icons.account_balance,
                    onTap: () {
                      Navigator.pushNamed(context, Profile.routeName);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),

            const Divider(height: 1, color: Colors.grey),

            // -------------------------------- Logout Button
            TextButton(
              child: const Text(
                "Log Out",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false)
                    .logOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final double width;
  final double iconSize;
  final double textSize;
  final Function() onTap;

  const IconTextButton({
    Key? key,
    required this.text,
    required this.icon,
    this.width = 100,
    this.iconSize = 30,
    this.textSize = 16,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize),
            Text(
              text,
              style: TextStyle(fontSize: textSize),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
