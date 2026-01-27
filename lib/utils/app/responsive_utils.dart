import 'package:flutter/material.dart';

extension ResponsiveUtils on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  bool get isSmallHeight => screenHeight < 480;
}
