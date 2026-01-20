import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';

class CreateQrScreen extends StatelessWidget {
  const CreateQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: Center(
        child: Text(
          'Create QR Screen',
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
