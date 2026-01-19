import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Center(
        child: Text('Onboarding Screen', style: AppTextStyles.largeTitle),
      ),
    );
  }
}
