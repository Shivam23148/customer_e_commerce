import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;

  static initSize(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    screenWidth = mediaQuery.width;
    screenHeight = mediaQuery.height;
  }
}

double getRelativeHeight(double percentage) {
  return percentage * SizeConfig.screenHeight;
}

double getRelativeWidth(double percentage) {
  return percentage * SizeConfig.screenWidth;
}
