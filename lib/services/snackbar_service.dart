import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class SnackbarService {
  static OverlayEntry? _currentOverlay;

  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor = AppColors.dark,
    Duration duration = const Duration(seconds: 3),
    bool showCloseButton = true,
  }) {
    _hide();

    final overlay = Overlay.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: topPadding + 30,
        left: 16,
        right: 16,
        child: Material(
          color: AppColors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: AppFonts.interRegular.copyWith(
                      fontSize: 14,
                      color: AppColors.primaryBg,
                    ),
                  ),
                ),
                if (showCloseButton) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _hide,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.primaryBg,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentOverlay!);

    if (duration.inMilliseconds > 0) {
      Future.delayed(duration, () {
        _hide();
      });
    }
  }

  static void _hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.success,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.negative,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.warning,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      duration: duration,
    );
  }
}
