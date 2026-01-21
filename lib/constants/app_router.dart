import 'package:flutter/material.dart';
import 'package:qr_master/constants/app_routes.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/screens/index.dart';

Map<String, WidgetBuilder> get appRoutes => {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
  AppRoutes.auth: (context) => const AuthScreen(),
  AppRoutes.main: (context) => const MainScreen(),
  AppRoutes.scanResult: (context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    return ScanResultScreen(scanItem: args as ScanHistoryItem?);
  },
  AppRoutes.subscription: (context) =>
      const Scaffold(body: Center(child: Text('Subscription Screen'))),
};
