import 'package:flutter/material.dart';
import 'package:qr_master/utils/index.dart';
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
    final isSmallHeight = context.isSmallHeight;
    final buttonSize = isSmallHeight ? ButtonSize.small : ButtonSize.big;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isSmallHeight) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Button(
                  text: currentPage == totalPages - 1 ? 'Get Started' : 'Next',
                  onPressed: onNext,
                  variant: ButtonVariant.primary,
                  size: buttonSize,
                ),
              ),
              if (currentPage < totalPages - 1) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Button(
                    text: 'Skip',
                    onPressed: onSkip,
                    variant: ButtonVariant.withoutBackground,
                    size: buttonSize,
                  ),
                ),
              ],
            ],
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              text: currentPage == totalPages - 1 ? 'Get Started' : 'Next',
              onPressed: onNext,
              variant: ButtonVariant.primary,
              size: buttonSize,
            ),
            if (currentPage < totalPages - 1) ...[
              const SizedBox(height: 16),
              Button(
                text: 'Skip',
                onPressed: onSkip,
                variant: ButtonVariant.withoutBackground,
                size: buttonSize,
              ),
            ] else ...[
              const SizedBox(height: 16),
              const SizedBox(height: 23),
            ],
          ],
        );
      },
    );
  }
}
