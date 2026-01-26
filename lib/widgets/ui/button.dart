import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

enum ButtonVariant { primary, withoutBackground }

enum ButtonSize { small, big }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final double? width;
  final double? height;
  final bool loading;
  final Widget? icon;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.big,
    this.width,
    this.height,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return _buildPrimaryButton();
      case ButtonVariant.withoutBackground:
        return _buildWithoutBackgroundButton();
    }
  }

  Widget _buildPrimaryButton() {
    final isSmall = size == ButtonSize.small;
    final buttonHeight = height ?? (isSmall ? 44.0 : 60.0);
    final fontSize = isSmall ? 15.0 : 17.0;
    final borderRadius = isSmall ? 14.0 : 18.0;

    return Container(
      width: width ?? double.infinity,
      height: buttonHeight,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBg,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[icon!, const SizedBox(width: 14)],
                      Text(
                        text,
                        style: AppFonts.interSemiBold.copyWith(
                          fontSize: fontSize,
                          height: 1.53,
                          letterSpacing: -0.5,
                          color: AppColors.primaryBg,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildWithoutBackgroundButton() {
    final isSmall = size == ButtonSize.small;
    final fontSize = isSmall ? 13.0 : 15.0;

    return SizedBox(
      width: width ?? double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: AppFonts.interRegular.copyWith(
            fontSize: fontSize,
            height: 1.53,
            letterSpacing: -0.5,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
