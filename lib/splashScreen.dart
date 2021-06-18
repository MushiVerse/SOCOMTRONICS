import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:socomtronics/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return  AnimatedSplashScreen(
       backgroundColor: Colors.transparent,
      splash: "lib/Assets/giphy3.gif",
      duration: 2000,
      splashIconSize: 500,
      splashTransition: SplashTransition.fadeTransition,
      nextScreen: Home(),
    );
  }
}