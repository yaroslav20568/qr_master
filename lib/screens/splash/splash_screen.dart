import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 500));

      if (!mounted) return;

      final storageService = StorageService();
      final isOnboardingCompleted = await storageService
          .isOnboardingCompleted();

      if (!mounted) return;

      final route = isOnboardingCompleted
          ? AppRoutes.home
          : AppRoutes.onboarding;

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: -50,
                  top: 508,
                  child: Container(
                    width: 97.66,
                    height: 97.66,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: -24.38,
                  top: 610.39,
                  child: Container(
                    width: 168.92,
                    height: 168.92,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: -14,
                  top: 547,
                  child: Container(
                    width: 87,
                    height: 87,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 52,
                  top: 216,
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 25,
                  top: 93,
                  child: Container(
                    width: 87,
                    height: 87,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -237.53,
                      top: -115.28,
                      child: Container(
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
                    ),
                    Positioned(
                      left: -217.12,
                      top: -94.87,
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
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [AppShadows.primaryGlow],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.qr_code_scanner,
                      size: 64,
                      color: Colors.white,
                    ),
                    Positioned(
                      right: -16.92,
                      top: -16,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -16,
                      bottom: -8.5,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -32,
                      top: 32,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.warning,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    Text('QR Master', style: AppTextStyles.largeTitle),
                    const SizedBox(height: 8),
                    Text(
                      'Scan • Create • Manage',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                const Loader(),
                const SizedBox(height: 50),
                Text(
                  'Version 1.0.0',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.textDisabled,
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
