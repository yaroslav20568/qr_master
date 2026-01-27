import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _onboardingKey = 'onboarding_completed';

  final Logger _logger = Logger();

  Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      _logger.e('Error checking onboarding status', error: e);
      return false;
    }
  }

  Future<bool> setOnboardingCompleted(bool completed) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_onboardingKey, completed);
    } catch (e) {
      _logger.e('Error saving onboarding status', error: e);
      return false;
    }
  }
}
