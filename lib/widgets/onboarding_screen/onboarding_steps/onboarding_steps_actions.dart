import 'package:flutter/material.dart';
import 'package:qr_master/widgets/ui/index.dart';

class OnboardingStepsActions extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingStepsActions({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Button(
          text: currentPage == totalPages - 1 ? 'Get Started' : 'Next',
          onPressed: onNext,
          variant: ButtonVariant.primary,
        ),
        if (currentPage < totalPages - 1) ...[
          const SizedBox(height: 16),
          Button(
            text: 'Skip',
            onPressed: onSkip,
            variant: ButtonVariant.withoutBackground,
          ),
        ] else ...[
          const SizedBox(height: 16),
          SizedBox(height: 23),
        ],
      ],
    );
  }
}
