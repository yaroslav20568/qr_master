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
                  gradient: AppGradients.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.45),
                      offset: Offset.zero,
                      blurRadius: 34.88,
                    ),
                  ],
                ),
              ),
              SvgPicture.asset('assets/icons/qr_code_icon.svg'),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              Text(
                AppInfo.appName,
                style: AppFonts.interBold.copyWith(
                  fontSize: 34,
                  height: 1.5,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan • Create • Manage',
                style: AppFonts.interRegular.copyWith(
                  fontSize: 15,
                  height: 1.53,
                  letterSpacing: -0.5,
                  color: AppColors.textSecondary,
                ),
              ),
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
                style: AppFonts.interRegular.copyWith(
                  fontSize: 13,
                  height: 1.54,
                  letterSpacing: -0.5,
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
