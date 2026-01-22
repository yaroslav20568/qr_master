import 'dart:typed_data';

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
  AppRoutes.createQrResult: (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) {
      return const Scaffold(body: Center(child: Text('Invalid arguments')));
    }
    return CreateQrResultScreen(
      qrImage: args['qrImage'] as Uint8List,
      content: args['content'] as String,
      type: args['type'] as QrCodeType,
      color: args['color'] as Color,
      qrCodeName: args['qrCodeName'] as String,
    );
  },
  AppRoutes.subscription: (context) =>
      const Scaffold(body: Center(child: Text('Subscription Screen'))),
};
