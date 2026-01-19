import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Center(child: Text('Home Screen', style: AppTextStyles.largeTitle)),
    );
  }
}
