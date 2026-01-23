import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/firebase_service.dart';
import 'package:qr_master/services/logger_service.dart';

class FirestoreService {
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

  Future<void> addScanHistoryItem(ScanHistoryItem item) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot add scan history item.',
      );
      return;
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to add scan history');
        return;
      }
      LoggerService.info('Adding scan history item: ${item.id}');
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .doc(item.id)
          .set(item.toJson());
      LoggerService.info('Scan history item added successfully');
    } catch (e) {
      LoggerService.error('Error adding scan history item', error: e);
      rethrow;
    }
  }

  Stream<List<ScanHistoryItem>> getScanHistoryStream({int limit = 3}) {
    if (!FirebaseService.isInitialized) {
      return Stream.value([]);
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Stream.value([]);
      }
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  try {
                    return ScanHistoryItem.fromJson(doc.data());
                  } catch (e) {
                    LoggerService.error(
                      'Error parsing scan history item',
                      error: e,
                    );
                    return null;
                  }
                })
                .whereType<ScanHistoryItem>()
                .toList();
          });
    } catch (e) {
      LoggerService.error('Error getting scan history stream', error: e);
      return Stream.value([]);
    }
  }

  Future<List<ScanHistoryItem>> getScanHistory({int limit = 50}) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot get scan history.',
      );
      return [];
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to get scan history');
        return [];
      }
      LoggerService.info('Getting scan history: limit=$limit');
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      final items = snapshot.docs
          .map((doc) {
            try {
              return ScanHistoryItem.fromJson(doc.data());
            } catch (e) {
              LoggerService.error('Error parsing scan history item', error: e);
              return null;
            }
          })
          .whereType<ScanHistoryItem>()
          .toList();
      LoggerService.info('Scan history loaded: ${items.length} items');
      return items;
    } catch (e) {
      LoggerService.error('Error getting scan history', error: e);
      return [];
    }
  }

  Future<void> deleteScanHistoryItem(String itemId) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot delete scan history item.',
      );
      return;
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning(
          'No authenticated user to delete scan history item',
        );
        return;
      }
      LoggerService.info('Deleting scan history item: $itemId');
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .doc(itemId)
          .delete();
      LoggerService.info('Scan history item deleted successfully');
    } catch (e) {
      LoggerService.error('Error deleting scan history item', error: e);
      rethrow;
    }
  }

  Future<void> deleteAllHistory() async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot delete all history.',
      );
      return;
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to delete all history');
        return;
      }
      LoggerService.info('Deleting all history items');
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('history')
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      LoggerService.info('All history items deleted successfully');
    } catch (e) {
      LoggerService.error('Error deleting all history', error: e);
      rethrow;
    }
  }

  Future<void> addCreatedQrCode(QrCode qrCode) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot add created QR code.',
      );
      return;
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to add created QR code');
        return;
      }
      LoggerService.info('Adding created QR code: ${qrCode.id}');
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('created_qr_codes')
          .doc(qrCode.id)
          .set(qrCode.toJson());
      LoggerService.info('Created QR code added successfully');
    } catch (e) {
      LoggerService.error('Error adding created QR code', error: e);
      rethrow;
    }
  }

  Stream<List<QrCode>> getCreatedQrCodesStream({int limit = 50}) {
    if (!FirebaseService.isInitialized) {
      return Stream.value([]);
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Stream.value([]);
      }
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('created_qr_codes')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) {
                  try {
                    return QrCode.fromJson(doc.data());
                  } catch (e) {
                    LoggerService.error(
                      'Error parsing created QR code',
                      error: e,
                    );
                    return null;
                  }
                })
                .whereType<QrCode>()
                .toList();
          });
    } catch (e) {
      LoggerService.error('Error getting created QR codes stream', error: e);
      return Stream.value([]);
    }
  }

  Future<List<QrCode>> getCreatedQrCodes({int limit = 50}) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot get created QR codes.',
      );
      return [];
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to get created QR codes');
        return [];
      }
      LoggerService.info('Getting created QR codes: limit=$limit');
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('created_qr_codes')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      final items = snapshot.docs
          .map((doc) {
            try {
              return QrCode.fromJson(doc.data());
            } catch (e) {
              LoggerService.error('Error parsing created QR code', error: e);
              return null;
            }
          })
          .whereType<QrCode>()
          .toList();
      LoggerService.info('Created QR codes loaded: ${items.length} items');
      return items;
    } catch (e) {
      LoggerService.error('Error getting created QR codes', error: e);
      return [];
    }
  }

  Future<void> deleteCreatedQrCode(String qrCodeId) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot delete created QR code.',
      );
      return;
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning(
          'No authenticated user to delete created QR code',
        );
        return;
      }
      LoggerService.info('Deleting created QR code: $qrCodeId');
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('created_qr_codes')
          .doc(qrCodeId)
          .delete();
      LoggerService.info('Created QR code deleted successfully');
    } catch (e) {
      LoggerService.error('Error deleting created QR code', error: e);
      rethrow;
    }
  }

  Future<void> updateQrCodeScanCount(String qrCodeId) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot update QR code scan count.',
      );
      return;
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to update scan count');
        return;
      }
      LoggerService.info('Updating scan count for QR code: $qrCodeId');
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('created_qr_codes')
          .doc(qrCodeId);
      await docRef.update({'scanCount': FieldValue.increment(1)});
      LoggerService.info('Scan count updated successfully');
    } catch (e) {
      LoggerService.error('Error updating scan count', error: e);
      rethrow;
    }
  }
}
