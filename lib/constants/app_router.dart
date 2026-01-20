import 'package:flutter/material.dart';
import 'package:qr_master/constants/app_routes.dart';
import 'package:qr_master/screens/index.dart';

Map<String, WidgetBuilder> get appRoutes => {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.main: (context) => const MainScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
  AppRoutes.scanResult: (context) => const ScanResultScreen(),
  AppRoutes.subscription: (context) =>
      const Scaffold(body: Center(child: Text('Subscription Screen'))),
};
