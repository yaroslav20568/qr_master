import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/index.dart';

enum InfoIndicatorType { success, error }

class InfoIndicator extends StatelessWidget {
  final String title;
  final String? text;
  final InfoIndicatorType type;

  const InfoIndicator({
    super.key,
    required this.title,
    this.text,
    this.type = InfoIndicatorType.success,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case InfoIndicatorType.success:
        return AppColors.success;
      case InfoIndicatorType.error:
        return Colors.red;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case InfoIndicatorType.success:
        return Icons.check;
      case InfoIndicatorType.error:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _getBackgroundColor(),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: BackgroundCircleIcon(
            size: 80,
            backgroundColor: _getBackgroundColor(),
            child: Icon(_getIcon(), size: 35, color: AppColors.primaryBg),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: AppFonts.interSemiBold.copyWith(
            fontSize: 17,
            height: 1.53,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        if (text != null) ...[
          const SizedBox(height: 4),
          Text(
            text!,
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
