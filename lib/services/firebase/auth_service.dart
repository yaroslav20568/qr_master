import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qr_master/services/app/logger_service.dart';
import 'package:qr_master/services/firebase/firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser {
    if (!FirebaseService.isInitialized) {
      return null;
    }
    return _auth.currentUser;
  }

  bool get isAuthenticated {
    if (!FirebaseService.isInitialized) {
      return false;
    }
    return _auth.currentUser != null;
  }

  Stream<User?> get authStateChanges {
    if (!FirebaseService.isInitialized) {
      return Stream.value(null);
    }
    return _auth.authStateChanges();
  }

  Future<User?> signInWithGoogle() async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot sign in with Google.',
      );
      return null;
    }

    try {
      LoggerService.info('Starting Google sign in');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        LoggerService.warning('Google sign in cancelled by user');
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      LoggerService.info(
        'Google sign in successful: ${userCredential.user?.email}',
      );

      return userCredential.user;
    } catch (e) {
      LoggerService.error('Error during Google sign in', error: e);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      LoggerService.info('Signing out user');
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      LoggerService.info('Sign out successful');
    } catch (e) {
      LoggerService.error('Error during sign out', error: e);
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      LoggerService.info('Deleting user account');
      await _auth.currentUser?.delete();
      await _googleSignIn.signOut();
      LoggerService.info('Account deletion successful');
    } catch (e) {
      LoggerService.error('Error during account deletion', error: e);
      rethrow;
    }
  }
}
