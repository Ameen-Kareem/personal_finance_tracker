import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_finance_tracker/constants/img_constants.dart';
import 'package:personal_finance_tracker/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:personal_finance_tracker/view/login/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key, required this.logStatus});
  final logStatus;
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool logStatus = false;
  @override
  void initState() {
    super.initState();
    logStatus = widget.logStatus;
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => logStatus ? BottomNavBar() : LoginScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset(ImageConstants.SPLASH)));
  }
}
