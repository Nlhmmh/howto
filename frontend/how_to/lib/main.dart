import 'package:flutter/material.dart';
import 'package:how_to/pages/bottom_navi.dart';
import 'package:how_to/pages/content_create.dart';
import 'package:how_to/pages/favourite.dart';
import 'package:how_to/pages/launch.dart';
import 'package:how_to/pages/login.dart';
import 'package:how_to/pages/my_contents.dart';
import 'package:how_to/pages/my_page.dart';
import 'package:how_to/pages/notification.dart';
import 'package:how_to/pages/profile.dart';
import 'package:how_to/pages/register.dart';
import 'package:how_to/pages/top.dart';
import 'package:how_to/providers/content_provider.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContentProvider()),
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
      initialRoute: LaunchPage.routeName,
      routes: {
        LaunchPage.routeName: (_) => const LaunchPage(),
        BottomNaviPage.routeName: (_) => const BottomNaviPage(pageIndex: 2),
        TopPage.routeName: (_) => const TopPage(),
        Registor.routeName: (_) => const Registor(),
        LoginPage.routeName: (_) => const LoginPage(),
        MyPage.routeName: (_) => const MyPage(),
        Profile.routeName: (_) => const Profile(),
        ContentCreate.routeName: (_) => const ContentCreate(),
        MyContentsPage.routeName: (_) => const MyContentsPage(),
        FavouritePage.routeName: (_) => const FavouritePage(),
        NotificationPage.routeName: (_) => const NotificationPage(),
      },
    );
  }
}
