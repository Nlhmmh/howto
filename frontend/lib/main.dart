import 'package:flutter/material.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/content_create.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/mypage.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/screens/register.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ContentProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'How To',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => const HomePage(),
        Registor.routeName: (_) => const Registor(),
        Login.routeName: (_) => const Login(),
        Profile.routeName: (_) => const Profile(),
        ContentCreate.routeName: (_) => const ContentCreate(),
        MyPage.routeName: (_) => const MyPage(),
      },
    );
  }
}
