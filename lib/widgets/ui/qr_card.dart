import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/ui/actions_dropdown.dart';

enum QrCardSize { s, l }

class QrCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String views;
  final QrCardSize size;
  final bool showMoreIcon;
  final VoidCallback? onTap;
  final List<ActionsDropdownItem>? actions;

  const QrCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.views,
    this.size = QrCardSize.s,
    this.showMoreIcon = true,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isLarge = size == QrCardSize.l;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isLarge ? 16 : 11),
        decoration: BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.circular(isLarge ? 16 : 11),
          border: Border.all(color: AppColors.border, width: 0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.06),
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
                    ? AppGradients.qrCardLargeGradient
                    : AppGradients.qrCardSmallGradient,
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
                  '${AppAssets.iconsPath}qr_code_icon.svg',
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppFonts.interSemiBold.copyWith(
                      fontSize: isLarge ? 15 : 10.17,
                      height: isLarge ? 1.53 : 1.53,
                      letterSpacing: isLarge ? -0.5 : -0.34,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showMoreIcon && actions != null && actions!.isNotEmpty)
                  ActionsDropdown(
                    items: actions!,
                    iconBackgroundSize: isLarge ? 24 : 16,
                  ),
              ],
            ),
            // SizedBox(height: isLarge ? 8 : 5),
            Text(
              subtitle,
              style: AppFonts.interRegular.copyWith(
                fontSize: isLarge ? 13 : 8.81,
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
                  style: AppFonts.interRegular.copyWith(
                    fontSize: isLarge ? 10 : 8.13,
                    height: isLarge ? 1.56 : 1.50,
                    letterSpacing: isLarge ? -0.5 : -0.34,
                    color: AppColors.textDisabled,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset('${AppAssets.iconsPath}eye_icon.svg'),
                    SizedBox(width: isLarge ? 4 : 3),
                    Text(
                      views,
                      style: AppFonts.interRegular.copyWith(
                        fontSize: isLarge ? 10 : 8.13,
                        height: isLarge ? 1.56 : 1.50,
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
      ),
    );
  }
}
