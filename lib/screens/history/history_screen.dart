import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/index.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: Center(
        child: Text(
          'History Screen',
          style: AppFonts.interBold.copyWith(
            fontSize: 34,
            height: 1.5,
            letterSpacing: -0.5,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
