import 'package:flutter/material.dart';
import 'package:frontend/pages/bottom_navi.dart';
import 'package:frontend/providers/content_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/pages/content_create.dart';
import 'package:frontend/pages/top.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/mypage.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/register.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'How To',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xff734444),
          secondary: Color(0xffeeedbe),
          secondaryContainer: Color(0xff99b27f),
        ),
      ),
      initialRoute: BottomNaviPage.routeName,
      // initialRoute: Profile.routeName,
      routes: {
        BottomNaviPage.routeName: (_) => const BottomNaviPage(pageIndex: 0),
        TopPage.routeName: (_) => const TopPage(),
        Registor.routeName: (_) => const Registor(),
        Login.routeName: (_) => const Login(),
        Profile.routeName: (_) => const Profile(),
        ContentCreate.routeName: (_) => const ContentCreate(),
        MyPage.routeName: (_) => const MyPage(),
      },
    );
  }
}
