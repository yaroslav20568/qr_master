import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';
import 'package:qr_master/widgets/onboarding_screen/onboarding_steps/onboarding_steps.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      gradient: AppGradients.onboardingGradient,
      child: const OnboardingSteps(),
    );
  }
}
