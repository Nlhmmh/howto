import 'package:flutter/material.dart';
import 'package:how_to/pages/bottom_navi.dart';
import 'package:how_to/pages/login.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/user_provider.dart';
import 'package:how_to/pages/profile.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  static const routeName = "/mypage";

  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  LoginData _loginData = LoginData();
  UserProfile _userProfile = UserProfile();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginData = await Provider.of<UserProvider>(context, listen: false)
          .getLoginData();
      _loginData = loginData;

      // Fetch UserProfile
      if (!mounted) return;
      final userProfile = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).fetchProfile();
      _userProfile = userProfile;

      setState(() {});
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
              width: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                maxRadius: 25,
                child: ClipOval(
                  child: _userProfile.imageUrl != ""
                      ? Image.network(
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          "${Constants.domainHttp}${_userProfile.imageUrl}",
                        )
                      : const Icon(Icons.person, size: 25),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // -------------------------------- Welcome
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _loginData.isLoggedIn ? _userProfile.displayName : "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // -------------------------------- User Type
            if (_loginData.isLoggedIn) ...[
              Text(
                _loginData.user.type,
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
                    if (_loginData.isLoggedIn) {
                      Navigator.pushNamed(context, Profile.routeName);
                    } else {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    }
                  },
                ),
                // -------------------------------- Favourite
                iconTextButton(
                  text: "Favourite",
                  icon: Icons.favorite,
                  onTap: () {
                    // TODO : Favourite Page
                    if (_loginData.isLoggedIn) {
                      Navigator.pushNamed(context, Profile.routeName);
                    } else {
                      Navigator.pushNamed(context, LoginPage.routeName);
                    }
                  },
                ),
              ],
            ),

            // -------------------------------- Content List
            if (_loginData.user.type == Constants.creatorAccType) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  iconTextButton(
                    text: "Content List",
                    icon: Icons.newspaper,
                    onTap: () {
                      Navigator.pushNamed(context, Profile.routeName);
                    },
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),

            // -------------------------------- Divider
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 30),

            // -------------------------------- Logout Btn
            if (_loginData.isLoggedIn) ...[
              // -------------------------------- Logout Btn
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: primaryBtn(
                  context: context,
                  text: "Logout",
                  onPressed: () async {
                    await Provider.of<UserProvider>(context, listen: false)
                        .logOut();
                    if (!mounted) return;
                    await Navigator.pushAndRemoveUntil(
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
                  context: context,
                  text: "Login",
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      LoginPage.routeName,
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
