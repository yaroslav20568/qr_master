import 'package:flutter/material.dart';
import 'package:qr_master/constants/app_routes.dart';
import 'package:qr_master/screens/index.dart';

Map<String, WidgetBuilder> get appRoutes => {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.home: (context) => const HomeScreen(),
  AppRoutes.onboarding: (context) => const OnboardingScreen(),
};
