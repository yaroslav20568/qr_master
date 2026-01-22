import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_master/services/logger_service.dart';

class ImageService {
  static const MethodChannel _channel = MethodChannel('qr_master/image_saver');

  static Future<bool> saveImageToGallery(Uint8List imageBytes) async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.photos.isGranted ||
            await Permission.storage.isGranted) {
          LoggerService.info('Storage permission already granted');
        } else {
          final result = await Permission.photos.request();
          if (!result.isGranted) {
            final storageResult = await Permission.storage.request();
            if (!storageResult.isGranted) {
              LoggerService.warning('Storage permission not granted');
              return false;
            }
          }
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.status;
        if (!status.isGranted) {
          final result = await Permission.photos.request();
          if (!result.isGranted) {
            LoggerService.warning('Photo permission not granted');
            return false;
          }
        }
      }

      LoggerService.info('Saving image to gallery');

      final tempDir = await getTemporaryDirectory();
      final fileName = 'qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      try {
        final result = await _channel.invokeMethod<bool>('saveImageToGallery', {
          'imagePath': file.path,
          'albumName': 'QR Master',
        });

        await file.delete();

        if (result == true) {
          LoggerService.info('Image saved to gallery: $fileName');
          return true;
        } else {
          LoggerService.warning('Failed to save image to gallery');
          return false;
        }
      } on PlatformException catch (e) {
        LoggerService.error('Platform channel error: ${e.message}', error: e);
        await file.delete();
        return false;
      }
    } catch (e) {
      LoggerService.error('Error saving image to gallery', error: e);
      return false;
    }
  }
}
