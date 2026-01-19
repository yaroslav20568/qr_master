import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBg = Color(0xFFFFFFFF);
  static const Color secondaryBg = Color(0xFFF6F7FA);

  static const Color primary = Color(0xFF7ACBFF);
  static const Color success = Color(0xFF77C97E);
  static const Color warning = Color(0xFFFFB86C);

  static const Color dark = Color(0xFF111111);

  static const Color textPrimary = dark;
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textDisabled = Color(0xFFB0B0B0);

  static const Color border = Color(0xFFE3E3E3);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7ACBFF), Color(0xFF4DA6FF)],
  );
}
