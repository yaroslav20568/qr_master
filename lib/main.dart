import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    LoggerService.warning('Warning: Could not load .env file: $e');
  }

  await AppInitializationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppRoutes.splash,
      routes: appRoutes,
      debugShowCheckedModeBanner: false,
    );
  }
}
