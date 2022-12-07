import 'package:flutter/material.dart';
import 'package:frontend/pages/bottom_navi.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/widgets.dart';
import 'package:frontend/providers/constants.dart';
import 'package:frontend/providers/models.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/pages/profile.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  static const routeName = "/mypage";

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // -------------------------------- Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                maxRadius: 25,
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
                    : const Icon(Icons.person, size: 25),
              ),
            ),
            const SizedBox(height: 10),

            // -------------------------------- Welcome
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),

            // -------------------------------- User Type
            if (_loginData.isLoggedIn) ...[
              Text(
                _loginData.user.accountType,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
            const SizedBox(height: 20),

            // -------------------------------- Divider
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 20),

            // -------------------------------- Profile, Favourite
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // -------------------------------- Profile
                iconTextButton(
                  text: "Profile",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, Profile.routeName);
                  },
                ),
                // -------------------------------- Favourite
                iconTextButton(
                  text: "Favourite",
                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.pushNamed(context, Profile.routeName);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // -------------------------------- Content List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // -------------------------------- Content List
                if (_loginData.user.accountType == Constants.creatorAccType)
                  iconTextButton(
                    text: "Content List",
                    icon: Icons.newspaper,
                    onTap: () {
                      Navigator.pushNamed(context, Profile.routeName);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // -------------------------------- Divider
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 30),

            // -------------------------------- Logout Btn
            if (_loginData.isLoggedIn) ...[
              // -------------------------------- Logout Btn
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: primaryBtn(
                  text: "Logout",
                  onPressed: () async {
                    await Provider.of<UserProvider>(context, listen: false)
                        .logOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BottomNaviPage(pageIndex: 0),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ] else ...[
              // -------------------------------- Login Btn
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: primaryBtn(
                  text: "Login",
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Login.routeName,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
