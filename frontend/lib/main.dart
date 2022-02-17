import 'package:flutter/material.dart';
import 'package:frontend/screens/home.dart';

void main() => runApp(const MyApp());

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
        HomePage.routeName: (ctx) => const HomePage(),
      },
    );
  }
}
