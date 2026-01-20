import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF7ACBFF), Color(0xFF4DA6FF)],
  );

  static const LinearGradient qrCardLargeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF7ACBFF), Color(0xFF4DA6FF)],
  );

  static const LinearGradient qrCardSmallGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF7ACBFF), Color(0xFF4DA6FF)],
  );

  static const LinearGradient onboardingGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F7FF), Color(0xFFFFFFFF)],
  );

  static const LinearGradient scanningLineGradient = LinearGradient(
    colors: [Color(0x00000000), Color(0xFF7ACBFF), Color(0x00000000)],
    stops: [0.0, 0.5, 1.0],
  );
}
