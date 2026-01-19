import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_master/constants/app_colors.dart';

class AppTextStyles {
  static TextStyle get largeTitle => GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get title1 => GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get title2 => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.53,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static TextStyle get caption => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.53,
    letterSpacing: -0.5,
    color: AppColors.textSecondary,
  );

  static TextStyle get button => GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.53,
    letterSpacing: -0.5,
    color: AppColors.primaryBg,
  );

  static TextStyle get tabBarLabel => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.5,
    color: AppColors.textSecondary,
  );

  static TextStyle get small => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.54,
    letterSpacing: -0.5,
    color: AppColors.textSecondary,
  );

  static TextStyle get smallBold => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.54,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );
}
