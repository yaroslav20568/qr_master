import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/dot.dart';

class CirclesLayout extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const CirclesLayout({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: screenWidth / 2 - 237.53,
                top: screenHeight / 2 - 237.53,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 475.06,
                      height: 475.06,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.border.withValues(alpha: 0.326),
                          width: 2,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 63,
                      child: const Dot(
                        size: 74,
                        opacity: 0.14,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      left: 27,
                      bottom: -105,
                      child: const Dot(
                        size: 128,
                        opacity: 0.1,
                        color: AppColors.success,
                      ),
                    ),
                    Positioned(
                      right: 25,
                      bottom: 15,
                      child: const Dot(
                        size: 87,
                        opacity: 0.06,
                        color: AppColors.warning,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 53,
                      child: const Dot(
                        size: 74,
                        opacity: 0.14,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      right: 45,
                      top: -80,
                      child: const Dot(
                        size: 87,
                        opacity: 0.06,
                        color: AppColors.warning,
                      ),
                    ),
                    Positioned(
                      right: 123,
                      top: 16,
                      child: const Dot(size: 12, color: AppColors.primary),
                    ),
                    Positioned(
                      left: 123,
                      bottom: 182,
                      child: const Dot(color: AppColors.success),
                    ),
                    Positioned(
                      left: 106,
                      top: 64,
                      child: const Dot(size: 6, color: AppColors.warning),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: screenWidth / 2 - 217.12,
                top: screenHeight / 2 - 217.12,
                child: Container(
                  width: 434.24,
                  height: 434.24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border.withValues(alpha: 0.086),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
