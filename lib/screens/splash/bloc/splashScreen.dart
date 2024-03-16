import 'package:flutter/material.dart';
import 'package:novaone/constants.dart';
import 'package:novaone/palette.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      body: Center(
        child: Image.asset(
          splashImage,
          width: 133.5,
          height: 133.5,
        ),
      ),
    );
  }
}
