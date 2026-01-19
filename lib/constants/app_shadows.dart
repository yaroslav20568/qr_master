import 'package:flutter/material.dart';

class AppShadows {
  static BoxShadow get soft => const BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    offset: Offset(0, 4),
    blurRadius: 16,
  );

  static BoxShadow get medium => const BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.08),
    offset: Offset(0, 8),
    blurRadius: 24,
  );

  static BoxShadow get primaryGlow => const BoxShadow(
    color: Color.fromRGBO(122, 203, 255, 0.45),
    offset: Offset(0, 0),
    blurRadius: 34.88,
  );
}
