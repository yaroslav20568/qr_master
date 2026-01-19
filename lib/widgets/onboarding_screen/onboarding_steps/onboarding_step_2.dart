import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class OnboardingStep2 extends StatelessWidget {
  const OnboardingStep2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Scan QR Codes',
          style: AppTextStyles.title1.copyWith(fontSize: 36, height: 1.19),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 43),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 39, horizontal: 38),
          decoration: BoxDecoration(
            color: AppColors.primaryBg,
            borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset('assets/icons/scan_qr_icon.svg'),
              Positioned(
                top: -16,
                right: -16,
                child: BackgroundCircleIcon(
                  child: SvgPicture.asset(
                    'assets/icons/flash_icon.svg',
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryBg,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -16,
                left: -16,
                child: BackgroundCircleIcon(
                  child: SvgPicture.asset(
                    'assets/icons/switch_camera_icon.svg',
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryBg,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 43),
        Column(
          children: [
            Text(
              'Quickly Scan Any QR Code',
              style: AppTextStyles.title2.copyWith(fontSize: 24, height: 1.46),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Align QR codes in frame and get instant results',
              style: AppTextStyles.body.copyWith(fontSize: 16, height: 1.31),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
