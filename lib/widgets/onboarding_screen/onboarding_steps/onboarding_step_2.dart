import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class OnboardingStep2 extends StatelessWidget {
  const OnboardingStep2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Scan QR Codes',
          style: AppTextStyles.title1.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 1.19,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxl),
        Expanded(
          child: Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
                border: Border.all(color: AppColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 40,
                    offset: Offset.zero,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppBorderRadius.xxl,
                        ),
                      ),
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: 150,
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    left: 18,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        border: Border(
                          top: BorderSide(color: AppColors.primaryBg, width: 4),
                          left: BorderSide(
                            color: AppColors.primaryBg,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        border: Border(
                          top: BorderSide(color: AppColors.primaryBg, width: 4),
                          right: BorderSide(
                            color: AppColors.primaryBg,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    left: 18,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primaryBg,
                            width: 4,
                          ),
                          left: BorderSide(
                            color: AppColors.primaryBg,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 18,
                    right: 18,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.primaryBg,
                            width: 4,
                          ),
                          right: BorderSide(
                            color: AppColors.primaryBg,
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              Text(
                'Quickly Scan Any QR Code',
                style: AppTextStyles.title2.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.46,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Align QR codes in frame and get instant results',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 16,
                  height: 1.31,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl * 2),
      ],
    );
  }
}
