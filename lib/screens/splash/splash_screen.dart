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
  late final Future<String> _versionFuture;

  @override
  void initState() {
    super.initState();
    _versionFuture = _loadVersion();
    _initializeApp();
  }

  Future<String> _loadVersion() async {
    try {
      await AppInfoService.initialize();
      return AppInfoService.versionString;
    } catch (e) {
      return 'Version 1.0.0';
    }
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 60));

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
                  child: const Dot(
                    size: 97.66,
                    opacity: 0.14,
                    color: AppColors.primary,
                  ),
                ),
                Positioned(
                  left: -24.38,
                  top: 610.39,
                  child: const Dot(
                    size: 168.92,
                    opacity: 0.1,
                    color: AppColors.success,
                  ),
                ),
                Positioned(
                  right: -14,
                  top: 547,
                  child: const Dot(
                    size: 87,
                    opacity: 0.06,
                    color: AppColors.warning,
                  ),
                ),
                Positioned(
                  right: 52,
                  top: 216,
                  child: const Dot(
                    size: 74,
                    opacity: 0.14,
                    color: AppColors.primary,
                  ),
                ),
                Positioned(
                  right: 25,
                  top: 93,
                  child: const Dot(
                    size: 87,
                    opacity: 0.06,
                    color: AppColors.warning,
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
                      child: const Dot(size: 12, color: AppColors.primary),
                    ),
                    Positioned(
                      left: -16,
                      bottom: -8.5,
                      child: const Dot(size: 8, color: AppColors.success),
                    ),
                    Positioned(
                      left: -32,
                      top: 32,
                      child: const Dot(size: 6, color: AppColors.warning),
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
                FutureBuilder<String>(
                  future: _versionFuture,
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'Version 1.0.0',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.textDisabled,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
