import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeActionsService {
  static Future<void> copyContent(BuildContext context, String content) async {
    try {
      await Clipboard.setData(ClipboardData(text: content));
      LoggerService.info('Copied to clipboard: $content');
      if (context.mounted) {
        SnackbarService.showSuccess(
          context,
          message: 'Copied to clipboard',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      LoggerService.error('Error copying to clipboard', error: e);
      if (context.mounted) {
        SnackbarService.showError(context, message: 'Failed to copy');
      }
    }
  }

  static Future<void> shareQrCode(
    BuildContext context,
    String content, {
    Uint8List? qrImage,
    Color? foregroundColor,
  }) async {
    try {
      Uint8List? imageToShare = qrImage;

      if (imageToShare == null) {
        final qrService = QrService();
        imageToShare = await qrService.generateQrCodeImage(
          data: content,
          size: 512,
          foregroundColor: foregroundColor ?? AppColors.dark,
        );
      }

      if (imageToShare != null) {
        final xFile = XFile.fromData(
          imageToShare,
          mimeType: 'image/png',
          name: 'qr_code.png',
        );
        await Share.shareXFiles([xFile]);
      } else {
        await Share.share(content);
      }

      LoggerService.info('Shared QR code image');
    } catch (e) {
      LoggerService.error('Error sharing QR code', error: e);
      if (context.mounted) {
        SnackbarService.showError(context, message: 'Failed to share');
      }
    }
  }

  static Future<void> saveToGallery(
    BuildContext context,
    String content, {
    Uint8List? qrImage,
    Color? foregroundColor,
  }) async {
    try {
      Uint8List? imageToSave = qrImage;

      if (imageToSave == null) {
        final qrService = QrService();
        imageToSave = await qrService.generateQrCodeImage(
          data: content,
          size: 512,
          foregroundColor: foregroundColor ?? AppColors.dark,
        );
      }

      if (imageToSave == null) {
        if (context.mounted) {
          SnackbarService.showError(
            context,
            message: 'Failed to generate QR code',
          );
        }
        return;
      }

      final saved = await ImageService.saveImageToGallery(imageToSave);
      if (saved) {
        LoggerService.info('QR code saved to gallery');
        if (context.mounted) {
          SnackbarService.showSuccess(
            context,
            message: 'Saved to gallery',
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        if (context.mounted) {
          SnackbarService.showError(
            context,
            message: 'Failed to save QR code to gallery',
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error saving QR code to gallery', error: e);
      if (context.mounted) {
        SnackbarService.showError(context, message: 'Failed to save');
      }
    }
  }

  static Future<void> openUrl(BuildContext context, String content) async {
    try {
      final uri = UrlUtils.normalizeUrl(content);
      LoggerService.info('Attempting to open URL: $uri');

      final canLaunch = await canLaunchUrl(uri);
      LoggerService.info('Can launch URL: $canLaunch');

      if (canLaunch) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        LoggerService.info('URL launch result: $launched');
        if (launched) {
          LoggerService.info('Successfully opened URL: $content');
        } else {
          LoggerService.warning('Failed to launch URL: $content');
          if (context.mounted) {
            SnackbarService.showWarning(context, message: 'Failed to open URL');
          }
        }
      } else {
        LoggerService.warning('Cannot launch URL: $content');
        if (context.mounted) {
          SnackbarService.showWarning(
            context,
            message: 'Cannot open this URL. No browser found.',
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error opening URL', error: e);
      if (context.mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to open URL: ${e.toString()}',
        );
      }
    }
  }

  static Future<void> callPhone(BuildContext context, String content) async {
    try {
      String phoneNumber = content;
      if (!phoneNumber.startsWith('tel:')) {
        phoneNumber = 'tel:$phoneNumber';
      }
      final uri = Uri.parse(phoneNumber);
      LoggerService.info('Attempting to call: $uri');

      final launched = await launchUrl(uri);
      if (launched) {
        LoggerService.info('Successfully initiated call: $content');
      } else {
        LoggerService.warning('Failed to initiate call: $content');
        if (context.mounted) {
          SnackbarService.showWarning(context, message: 'Failed to make call');
        }
      }
    } catch (e) {
      LoggerService.error('Error making call', error: e);
      if (context.mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to make call: ${e.toString()}',
        );
      }
    }
  }

  static Future<void> sendEmail(BuildContext context, String content) async {
    try {
      String emailUri = content;
      if (!emailUri.startsWith('mailto:')) {
        emailUri = 'mailto:$emailUri';
      }
      final uri = Uri.parse(emailUri);
      LoggerService.info('Attempting to send email: $uri');

      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri);
        if (launched) {
          LoggerService.info('Successfully opened email: $content');
        } else {
          LoggerService.warning('Failed to open email: $content');
          if (context.mounted) {
            SnackbarService.showWarning(
              context,
              message: 'Failed to open email',
            );
          }
        }
      } else {
        LoggerService.warning('Cannot open email: $content');
        if (context.mounted) {
          SnackbarService.showWarning(
            context,
            message: 'Cannot open email. No email app found.',
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error sending email', error: e);
      if (context.mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to send email: ${e.toString()}',
        );
      }
    }
  }

  static Future<void> addContact(BuildContext context, String content) async {
    try {
      if (context.mounted) {
        SnackbarService.showWarning(
          context,
          message: 'Contact import feature is not available on this device',
          duration: const Duration(seconds: 3),
        );
      }
      LoggerService.info('Contact import requested for: $content');
    } catch (e) {
      LoggerService.error('Error adding contact', error: e);
      if (context.mounted) {
        SnackbarService.showError(context, message: 'Failed to add contact');
      }
    }
  }

  static Future<void> connectToWifi(
    BuildContext context,
    String content,
  ) async {
    try {
      if (context.mounted) {
        SnackbarService.showWarning(
          context,
          message: 'WiFi connection feature is not available on this device',
          duration: const Duration(seconds: 3),
        );
      }
      LoggerService.info('WiFi connection requested for: $content');
    } catch (e) {
      LoggerService.error('Error connecting to WiFi', error: e);
      if (context.mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to connect to WiFi',
        );
      }
    }
  }

  static Future<void> openByType(
    BuildContext context,
    String content,
    QrCodeType type,
  ) async {
    switch (type) {
      case QrCodeType.url:
        await openUrl(context, content);
        break;
      case QrCodeType.phone:
        await callPhone(context, content);
        break;
      case QrCodeType.email:
        await sendEmail(context, content);
        break;
      case QrCodeType.contact:
      case QrCodeType.wifi:
      case QrCodeType.text:
        break;
    }
  }
}
