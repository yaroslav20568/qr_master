import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle get interRegular =>
      GoogleFonts.inter(fontWeight: FontWeight.w400);

  static TextStyle get interMedium =>
      GoogleFonts.inter(fontWeight: FontWeight.w500);

  static TextStyle get interSemiBold =>
      GoogleFonts.inter(fontWeight: FontWeight.w600);

  static TextStyle get interBold =>
      GoogleFonts.inter(fontWeight: FontWeight.w700);
}
