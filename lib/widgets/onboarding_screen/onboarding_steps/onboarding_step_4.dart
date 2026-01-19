import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class OnboardingStep4 extends StatelessWidget {
  const OnboardingStep4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Text(
          'Manage & Share',
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildQrCard(
                  title: 'My Website',
                  subtitle: 'portfolio.com',
                  date: 'Dec 15, 2024',
                  views: '67',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildQrCard(
                  title: 'My Website',
                  subtitle: 'portfolio.com',
                  date: 'Dec 15, 2024',
                  views: '67',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildQrCard(
                  title: 'Contact Info',
                  subtitle: 'John Doe vCard',
                  date: 'Dec 12, 2024',
                  views: '12',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildQrCard(
                  title: 'Contact Info',
                  subtitle: 'John Doe vCard',
                  date: 'Dec 12, 2024',
                  views: '12',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              Text(
                'Save, Share, and Track All\nYour QR Codes',
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
                'Access My QR Codes and History anytime',
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

  Widget _buildQrCard({
    required String title,
    required String subtitle,
    required String date,
    required String views,
  }) {
    return Container(
      width: 327,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [AppShadows.soft],
      ),
      child: Row(
        children: [
          Container(
            width: 123.5,
            height: 96,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              boxShadow: [AppShadows.primaryGlow],
            ),
            child: Icon(Icons.qr_code_2, size: 60, color: AppColors.primaryBg),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      size: 16,
                      color: AppColors.textDisabled,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.small.copyWith(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: AppTextStyles.small.copyWith(
                        fontSize: 8,
                        color: AppColors.textDisabled,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 9,
                          color: AppColors.textDisabled,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          views,
                          style: AppTextStyles.small.copyWith(
                            fontSize: 8,
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
