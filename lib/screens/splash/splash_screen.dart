import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/splash_screen/index.dart';

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
      await Future.delayed(const Duration(seconds: 5));

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Stack(
            children: [
              CirclesLayout(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SplashScreenContent(versionFuture: _versionFuture),
            ],
          );
        },
      ),
    );
  }
}
