import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/dot.dart';

class OnboardingStepsIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingStepsIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        if (index == currentPage) {
          return Container(
            width: 32,
            height: 8,
            margin: EdgeInsets.only(
              right: index < totalPages - 1 ? AppSpacing.xs : 0,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppBorderRadius.full),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(
              right: index < totalPages - 1 ? AppSpacing.xs : 0,
            ),
            child: const Dot(size: 8, color: AppColors.border),
          );
        }
      }),
    );
  }
}
