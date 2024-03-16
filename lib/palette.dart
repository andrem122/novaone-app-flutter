import 'package:flutter/material.dart';

class Palette {
  // Colors used throughout the app
  static const primaryColor = Color(0xff536cdb);
  static const secondaryColor = Color(0xff8cc1ff);
  static const teritiaryColor = Color(0xff2b2963);
  static const purpleColor = Color(0xff7E53DB);
  static const indigoColor = Color(0xff2B4AD0);
  static const boxShadow = Color(0xff0C9869);
  static const textColor = Color(0xff444444);

  static final List<Color> appColors = [
    primaryColor,
    secondaryColor,
    teritiaryColor,
    purpleColor,
    indigoColor,
  ];

  static const LinearGradient greetingContainerGradient = LinearGradient(
      colors: [primaryColor, purpleColor, indigoColor, Color(0xff53B0DB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [0, 0.2, 0.5, 0.8] //stops for individual color
      //set the stops number equal to numbers of color
      );

  // The colors used in the gradient
  static const gradientColors = [
    primaryColor,
    purpleColor,
    indigoColor,
    Color(0xff53B0DB)
  ];

  // Where the gradient starts from
  static const gradientFrom = Offset(0, 1);

  // Where the gradient ends to
  static const gradientTo = Offset(0, 0);

  // The stops of colors the gradient has
  static const List<double> gradientColorStops = [0, 0.2, 0.5, 0.8];

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFdadae3),
      Color(0xFFededed),
      Color(0xFFdfdfe8),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );
}
