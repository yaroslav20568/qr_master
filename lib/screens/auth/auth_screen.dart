import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();
  final UserProfileService _userProfileService = UserProfileService();
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      LoggerService.info('Starting Google sign in from auth screen');

      final user = await _authService.signInWithGoogle();

      if (user == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      LoggerService.info('Google sign in successful: ${user.email}');

      final existingProfile = await _userProfileService.getUserProfile();

      if (existingProfile == null) {
        await _userProfileService.createUserProfile(user);
      } else {
        await _userProfileService.updateUserProfile({
          'lastLoginAt': DateTime.now().toIso8601String(),
        });
      }

      await FirebaseService.setUserId(user.uid);
      await FirebaseService.setUserProperty(name: 'email', value: user.email);

      if (!mounted) return;

      await FirebaseService.logEvent(
        name: 'sign_in',
        parameters: {'method': 'google'},
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    } catch (e) {
      LoggerService.error('Error during Google sign in', error: e);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        SnackbarService.showError(
          context,
          message: 'Sign in failed: ${e.toString()}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      backgroundColor: AppColors.primaryBg,
      child: AuthScreenContent(
        onSignIn: _signInWithGoogle,
        isLoading: _isLoading,
      ),
    );
  }
}
