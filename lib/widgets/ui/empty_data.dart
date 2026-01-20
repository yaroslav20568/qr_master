import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class EmptyData extends StatelessWidget {
  final String title;

  const EmptyData({super.key, this.title = 'No items found'});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppFonts.interRegular.copyWith(
        fontSize: 15,
        height: 1.53,
        letterSpacing: -0.5,
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
