import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';

class OnboardingStep1 extends StatelessWidget {
  const OnboardingStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome',
          style: AppFonts.interBold.copyWith(
            fontSize: 36,
            height: 1.19,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 37),
        SvgPicture.asset('assets/icons/welcome_icon.svg'),
        const SizedBox(height: 38),
        Text(
          'Scan, Create & Manage QR Codes Easily',
          style: AppFonts.interSemiBold.copyWith(
            fontSize: 24,
            height: 1.46,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
