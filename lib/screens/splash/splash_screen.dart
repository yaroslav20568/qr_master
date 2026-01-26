import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  final AuthService _authService = AuthService();
  final UserProfileService _userProfileService = UserProfileService();
  AppOpenAd? _appOpenAd;

  @override
  void initState() {
    super.initState();
    _versionFuture = _loadVersion();
    _loadAppOpenAd();
    _initializeApp();
  }

  void _loadAppOpenAd() {
    AdsService().loadAppOpenAd(
      onAdLoaded: (ad) {
        _appOpenAd = ad;
        _appOpenAd?.show();
        AnalyticsService().logEvent(name: 'app_open_ad_loaded');
      },
      onAdFailedToLoad: (error) {
        LoggerService.warning('App open ad failed to load: $error');
      },
    );
  }

  Future<String> _loadVersion() async {
    try {
      await AppInfoService.initialize();
      return AppInfoService.versionString;
    } catch (e) {
      return AppInfo.defaultVersionString;
    }
  }

  Future<void> _initializeApp() async {
    try {
      LoggerService.info('Initializing app');

      if (!mounted) return;

      final isAuthenticated = _authService.isAuthenticated;

      if (isAuthenticated) {
        await _checkAuthAndSetupUser();
      }

      if (!mounted) return;

      final storageService = StorageService();
      final isOnboardingCompleted = await storageService
          .isOnboardingCompleted();

      if (!mounted) return;

      await AnalyticsService().logAppOpen();

      String route;

      if (isAuthenticated) {
        route = AppRoutes.main;
      } else if (isOnboardingCompleted) {
        route = AppRoutes.auth;
      } else {
        route = AppRoutes.onboarding;
      }

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(route);
      }
    } catch (e) {
      LoggerService.error('Error during app initialization', error: e);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
      }
    }
  }

  Future<void> _checkAuthAndSetupUser() async {
    try {
      final user = _authService.currentUser;

      if (user != null) {
        LoggerService.info('User authenticated: ${user.email}');

        final existingProfile = await _userProfileService.getUserProfile();

        if (existingProfile == null) {
          await _userProfileService.createUserProfile(user);
        } else {
          await _userProfileService.updateUserProfile({
            'lastLoginAt': DateTime.now().toIso8601String(),
          });
        }

        await AnalyticsService().setUserId(user.uid);
        await AnalyticsService().setUserProperty(
          name: 'email',
          value: user.email,
        );
      } else {
        LoggerService.info('No authenticated user');
      }
    } catch (e) {
      LoggerService.error('Error checking auth status', error: e);
    }
  }

  @override
  void dispose() {
    _appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      backgroundColor: AppColors.primaryBg,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          return Stack(
            children: [
              CirclesLayout(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              SplashContent(versionFuture: _versionFuture),
            ],
          );
        },
      ),
    );
  }
}
