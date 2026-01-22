import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class SectionLayout extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionLayout({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.interSemiBold.copyWith(
            fontSize: 17,
            height: 1.53,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}
