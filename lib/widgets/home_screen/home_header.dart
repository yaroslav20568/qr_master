import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class HomeHeader extends StatelessWidget {
  final String? userName;

  const HomeHeader({super.key, this.userName});

  @override
  Widget build(BuildContext context) {
    final displayName = userName ?? 'Name';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, $displayName!',
          style: AppFonts.interBold.copyWith(
            fontSize: 28,
            height: 1.5,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Manage your QR codes easily',
          style: AppFonts.interRegular.copyWith(
            fontSize: 15,
            height: 1.53,
            letterSpacing: -0.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
