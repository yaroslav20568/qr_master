import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/index.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      gradient: AppGradients.screenGradient,
      child: PaddingLayout(child: const OnboardingSteps()),
    );
  }
}
