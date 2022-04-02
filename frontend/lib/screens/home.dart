import 'package:flutter/material.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/register.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User _user = User();
  List<Content> _contentList = [];

  @override
  void initState() {
    super.initState();

    Future(() async {
      final contentList =
          await Provider.of<ContentProvider>(context, listen: false)
              .fetchContent();
      setState(() {
        _contentList = contentList;
        _user = Provider.of<UserProvider>(context, listen: false).user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            children: [
              // -------------------------------- Avatar
              Expanded(
                flex: 1,
                child: PopupMenuButton(
                  child: CircleAvatar(
                    backgroundColor: _user.isLoggedIn
                        ? _user.avatarColor.color
                        : Colors.white,
                    child: _user.isLoggedIn
                        ? Text(
                            _user.displayName.characters.first.toUpperCase(),
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
                    if (!_user.isLoggedIn)
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.login),
                          title: const Text('Login'),
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () {
                            Navigator.pushNamed(context, Login.routeName);
                          },
                        ),
                      ),
                    // -------------------------------- Register Btn
                    if (!_user.isLoggedIn)
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.person_add),
                          title: const Text('Register'),
                          contentPadding: const EdgeInsets.all(0),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Registor.routeName,
                            );
                          },
                        ),
                      ),
                    // -------------------------------- Profile Btn
                    if (_user.isLoggedIn)
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
                    if (_user.isLoggedIn)
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
      body: LayoutBuilder(
        builder: (context, constraints) => GridView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: _contentList.length,
          itemBuilder: (BuildContext context, int index) => Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _contentList[index].title,
                    ),
                    Text(
                      _contentList[index].category,
                    ),
                    Text(
                      _contentList[index].viewCount.toString(),
                    ),
                    Text(
                      _contentList[index].updatedAt.toString(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
