import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/firebase/firebase_service.dart';
import 'package:qr_master/services/logger_service.dart';

class QrCodeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Stream<List<QrCode>> getCreatedQrCodesStream({int limit = 100}) {
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

  Future<void> updateQrCodeScanView(String qrCodeId) async {
    if (!FirebaseService.isInitialized) {
      LoggerService.warning(
        'Firebase not initialized. Cannot update QR code scan view.',
      );
      return;
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        LoggerService.warning('No authenticated user to update scan view');
        return;
      }
      LoggerService.info('Updating scan view for QR code: $qrCodeId');
      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('created_qr_codes')
          .doc(qrCodeId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        LoggerService.warning('QR code document not found: $qrCodeId');
        return;
      }

      await docRef.update({'scanView': FieldValue.increment(1)});
      LoggerService.info('Scan view updated successfully');
    } catch (e) {
      LoggerService.error('Error updating scan view', error: e);
      rethrow;
    }
  }
}
