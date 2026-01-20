import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/loader/loading_dots.dart';

class Loader extends StatelessWidget {
  final bool showText;

  const Loader({super.key, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LoadingDots(),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: AppFonts.interRegular.copyWith(
              fontSize: 15,
              height: 1.53,
              letterSpacing: -0.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
