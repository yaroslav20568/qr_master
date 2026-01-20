import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class SplashScreenContent extends StatelessWidget {
  final Future<String> versionFuture;

  const SplashScreenContent({super.key, required this.versionFuture});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [AppShadows.primaryGlow],
                ),
              ),
              SvgPicture.asset('assets/icons/qr_code_icon.svg'),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              Text('QR Master', style: AppTextStyles.largeTitle),
              const SizedBox(height: 8),
              Text('Scan • Create • Manage', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 50),
          const Loader(),
          const SizedBox(height: 50),
          FutureBuilder<String>(
            future: versionFuture,
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? AppInfo.defaultVersionString,
                style: AppTextStyles.small.copyWith(
                  color: AppColors.textDisabled,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
