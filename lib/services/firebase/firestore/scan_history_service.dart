import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/app/logger_service.dart';
import 'package:qr_master/services/firebase/firebase_service.dart';

class ScanHistoryService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Stream<List<ScanHistoryItem>> getScanHistoryStream({int limit = 100}) {
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
}
