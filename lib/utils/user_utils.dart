import 'package:qr_master/services/index.dart';

class UserUtils {
  static String? getUserDisplayName() {
    final authService = AuthService();
    final user = authService.currentUser;

    if (user == null) {
      return null;
    }

    return user.displayName ?? user.email?.split('@').first ?? 'User';
  }
}
