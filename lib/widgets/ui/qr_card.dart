import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/background_circle_icon.dart';

enum QrCardSize { s, l }

class QrCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String views;
  final QrCardSize size;

  const QrCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.views,
    this.size = QrCardSize.s,
  });

  @override
  Widget build(BuildContext context) {
    final isLarge = size == QrCardSize.l;

    return Container(
      padding: EdgeInsets.all(isLarge ? 16 : 11),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(isLarge ? 16 : 11),
        border: Border.all(color: AppColors.border, width: 0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: Offset(0, isLarge ? 4 : 2.71),
            blurRadius: isLarge ? 16 : 10.84,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: isLarge ? 96 : 65,
            decoration: BoxDecoration(
              gradient: isLarge
                  ? AppColors.qrCardLargeGradient
                  : AppColors.qrCardSmallGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.45),
                  offset: Offset.zero,
                  blurRadius: isLarge ? 35 : 24,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/qr_code_icon.svg',
                width: isLarge ? 42 : 28,
                height: isLarge ? 42 : 28,
                colorFilter: ColorFilter.mode(
                  AppColors.primaryBg,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(height: isLarge ? 12 : 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: isLarge ? 15 : 10.17,
                    fontWeight: FontWeight.w600,
                    height: isLarge ? 23 / 15 : 15.6 / 10.17,
                    letterSpacing: isLarge ? -0.5 : -0.34,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              BackgroundCircleIcon(
                size: isLarge ? 24 : 16,
                backgroundColor: AppColors.secondaryBg,
                child: SvgPicture.asset('assets/icons/more_icon.svg'),
              ),
            ],
          ),
          SizedBox(height: isLarge ? 8 : 5),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: isLarge ? 13 : 8.81,
              fontWeight: FontWeight.w400,
              letterSpacing: isLarge ? -0.5 : -0.34,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isLarge ? 11 : 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: GoogleFonts.inter(
                  fontSize: isLarge ? 10 : 8.13,
                  fontWeight: FontWeight.w400,
                  height: isLarge ? 15.6 / 10 : 12.2 / 8.13,
                  letterSpacing: isLarge ? -0.5 : -0.34,
                  color: AppColors.textDisabled,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/eye_icon.svg'),
                  SizedBox(width: isLarge ? 4 : 3),
                  Text(
                    views,
                    style: GoogleFonts.inter(
                      fontSize: isLarge ? 10 : 8.13,
                      fontWeight: FontWeight.w400,
                      height: isLarge ? 15.6 / 10 : 12.2 / 8.13,
                      letterSpacing: isLarge ? -0.5 : -0.34,
                      color: AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
