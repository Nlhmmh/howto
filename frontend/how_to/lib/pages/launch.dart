import 'package:flutter/material.dart';
import 'package:how_to/pages/bottom_navi.dart';

class LaunchPage extends StatefulWidget {
  static const routeName = "/launch";

  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _loading = true;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNaviPage(pageIndex: 0),
        ),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset("assets/images/logo1.png"),
          ),
          if (_loading)
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
        ],
      ),
    );
  }
}
