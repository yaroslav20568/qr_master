import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class ScanInfoBanner extends StatelessWidget {
  const ScanInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grayLight, width: 0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          BackgroundCircleIcon(
            size: 40,
            backgroundColor: AppColors.primary,
            child: SvgPicture.asset('assets/icons/info_icon.svg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Align QR code within frame',
                  style: AppFonts.interRegular.copyWith(
                    fontSize: 15,
                    height: 23 / 15,
                    letterSpacing: -0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Keep your device steady',
                  style: AppFonts.interRegular.copyWith(
                    fontSize: 13,
                    height: 20 / 13,
                    letterSpacing: -0.5,
                    color: const Color(0xFFB0B0B0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
