import 'package:flutter/material.dart';
import 'package:frontend/providers/constants.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/providers/utils.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/screens/widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";
  static const routeIndex = 0;

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginData _loginData = LoginData();
  List<Content> _contentList = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      final loginData = await Provider.of<UserProvider>(context, listen: false)
          .getLoginData();
      final contentList =
          await Provider.of<ContentProvider>(context, listen: false)
              .fetchContent();
      setState(() {
        _contentList = contentList;
        _loginData = loginData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavi(
        selIndex: HomePage.routeIndex,
      ),
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              // -------------------------------- Avatar
              Expanded(
                flex: 1,
                child: PopupMenuButton(
                  child: CircleAvatar(
                    backgroundColor: _loginData.isLoggedIn
                        ? Constants
                            .avatarColorList[_loginData.user.avatarColorIndex]
                            .color
                        : Colors.white,
                    child: _loginData.isLoggedIn
                        ? Text(
                            _loginData.user.displayName.characters.first
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          )
                        : const Icon(Icons.person),
                  ),
                  itemBuilder: (BuildContext context) => [
                    // -------------------------------- Login Btn
                    if (!_loginData.isLoggedIn)
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.login),
                          title: const Text('Login'),
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              Login.routeName,
                            );
                          },
                        ),
                      ),
                    // -------------------------------- Register Btn
                    if (!_loginData.isLoggedIn)
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.person_add),
                          title: const Text('Register'),
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              Registor.routeName,
                            );
                          },
                        ),
                      ),
                    // -------------------------------- Profile Btn
                    if (_loginData.isLoggedIn)
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Profile'),
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Profile(),
                              ),
                              // (route) => false,
                            );
                          },
                        ),
                      ),
                    // -------------------------------- Logout Btn
                    if (_loginData.isLoggedIn)
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Log Out'),
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () async {
                            Provider.of<UserProvider>(context, listen: false)
                                .logOut();
                            Navigator.pop(context);
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // -------------------------------- Title
              const Expanded(
                flex: 9,
                child: Text(
                  'HowTo',
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
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
              // -------------------------------- Content Card
              child: Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: const Center(
                          child: Text(
                            "No Image",
                          ),
                        ),
                      ),
                      Text(
                        _contentList[index].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _contentList[index].category.toUpperCase(),
                      ),
                      Text(
                        "By ${_contentList[index].userName}",
                      ),
                      Text(
                        Utils.timeAgo(_contentList[index].updatedAt),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye_sharp),
                          const SizedBox(width: 5),
                          Text(
                            _contentList[index].viewCount.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
