import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/dot.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            top: -14,
            child: const Dot(size: 87, opacity: 0.06, color: AppColors.warning),
          ),
          Positioned(
            right: -47,
            top: 109,
            child: const Dot(size: 74, opacity: 0.06, color: AppColors.primary),
          ),
          Positioned(
            right: -32,
            bottom: 6,
            child: const Dot(size: 87, opacity: 0.06, color: AppColors.warning),
          ),
          Positioned(
            left: -64,
            top: 18,
            child: const Dot(size: 74, opacity: 0.06, color: AppColors.primary),
          ),
          Positioned(
            left: -51,
            bottom: 74,
            child: const Dot(
              size: 128,
              opacity: 0.06,
              color: AppColors.success,
            ),
          ),
          Column(
            children: [
              Container(
                width: 217,
                height: 217,
                padding: EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.45),
                      blurRadius: 35,
                    ),
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.06),
                      blurRadius: 46,
                      offset: Offset(0, 12),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 32,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  '${AppAssets.iconsPath}scan_qr_icon.svg',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Unlock Full QR Tools',
                style: AppFonts.interBold.copyWith(
                  fontSize: 34,
                  height: 1.11,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 13),
              Text(
                'Unlimited scans, custom QR creation, and full history access.',
                style: AppFonts.interRegular.copyWith(
                  fontSize: 15,
                  height: 1.67,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
