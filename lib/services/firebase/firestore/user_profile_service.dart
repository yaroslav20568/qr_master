import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_master/services/firebase/firebase_service.dart';
import 'package:qr_master/services/logger_service.dart';

class UserProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile(User user) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot create user profile.',
      );
      return;
    }

    try {
      LoggerService.info('Creating user profile: ${user.uid}');

      final userData = {
        'uid': user.uid,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      LoggerService.info('User profile created successfully');
    } catch (e) {
      LoggerService.error('Error creating user profile', error: e);
      rethrow;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot update user profile.',
      );
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to update profile');
        return;
      }

      LoggerService.info('Updating user profile: ${user.uid}');

      await _firestore.collection('users').doc(user.uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      LoggerService.info('User profile updated successfully');
    } catch (e) {
      LoggerService.error('Error updating user profile', error: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot get user profile.',
      );
      return null;
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to get profile');
        return null;
      }

      LoggerService.info('Getting user profile: ${user.uid}');

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        LoggerService.warning('User profile not found: ${user.uid}');
        return null;
      }

      return doc.data();
    } catch (e) {
      LoggerService.error('Error getting user profile', error: e);
      return null;
    }
  }
}
