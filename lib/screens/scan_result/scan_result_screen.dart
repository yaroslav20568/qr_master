import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: Center(
        child: Text(
          'Scan QR Screen',
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
