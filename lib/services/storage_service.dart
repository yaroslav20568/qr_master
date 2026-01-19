import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:qr_master/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _qrCodesKey = 'qr_codes';
  static const String _historyKey = 'scan_history';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _subscriptionKey = 'subscription_info';

  final Logger _logger = Logger();

  Future<List<QrCode>> getQrCodes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_qrCodesKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => QrCode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.e('Error loading QR codes', error: e);
      return [];
    }
  }

  Future<bool> saveQrCode(QrCode qrCode) async {
    try {
      final codes = await getQrCodes();
      final existingIndex = codes.indexWhere((c) => c.id == qrCode.id);

      if (existingIndex >= 0) {
        codes[existingIndex] = qrCode;
      } else {
        codes.add(qrCode);
      }

      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(codes.map((c) => c.toJson()).toList());
      return await prefs.setString(_qrCodesKey, jsonString);
    } catch (e) {
      _logger.e('Error saving QR code', error: e);
      return false;
    }
  }

  Future<bool> deleteQrCode(String id) async {
    try {
      final codes = await getQrCodes();
      codes.removeWhere((c) => c.id == id);

      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(codes.map((c) => c.toJson()).toList());
      return await prefs.setString(_qrCodesKey, jsonString);
    } catch (e) {
      _logger.e('Error deleting QR code', error: e);
      return false;
    }
  }

  Future<List<ScanHistoryItem>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_historyKey);
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ScanHistoryItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _logger.e('Error loading history', error: e);
      return [];
    }
  }

  Future<bool> addHistoryItem(ScanHistoryItem item) async {
    try {
      final history = await getHistory();
      history.insert(0, item);

      if (history.length > 1000) {
        history.removeRange(1000, history.length);
      }

      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(history.map((h) => h.toJson()).toList());
      return await prefs.setString(_historyKey, jsonString);
    } catch (e) {
      _logger.e('Error saving history item', error: e);
      return false;
    }
  }

  Future<bool> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_historyKey);
    } catch (e) {
      _logger.e('Error clearing history', error: e);
      return false;
    }
  }

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

  Future<SubscriptionInfo?> getSubscriptionInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_subscriptionKey);
      if (jsonString == null) return null;

      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return SubscriptionInfo(
        status: SubscriptionStatus.values.firstWhere(
          (e) => e.name == jsonData['status'],
          orElse: () => SubscriptionStatus.none,
        ),
        expiresAt: jsonData['expiresAt'] != null
            ? DateTime.parse(jsonData['expiresAt'])
            : null,
        productId: jsonData['productId'] as String?,
        isTrial: jsonData['isTrial'] as bool? ?? false,
      );
    } catch (e) {
      _logger.e('Error loading subscription info', error: e);
      return null;
    }
  }

  Future<bool> saveSubscriptionInfo(SubscriptionInfo info) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = {
        'status': info.status.name,
        'expiresAt': info.expiresAt?.toIso8601String(),
        'productId': info.productId,
        'isTrial': info.isTrial,
      };
      final jsonString = jsonEncode(json);
      return await prefs.setString(_subscriptionKey, jsonString);
    } catch (e) {
      _logger.e('Error saving subscription info', error: e);
      return false;
    }
  }
}
