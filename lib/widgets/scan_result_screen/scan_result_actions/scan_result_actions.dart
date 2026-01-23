import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/scan_result_screen/scan_result_actions/scan_result_primary_action.dart';
import 'package:qr_master/widgets/ui/qr_code_action.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanResultActions extends StatelessWidget {
  final ScanHistoryItem scanItem;

  const ScanResultActions({super.key, required this.scanItem});

  Future<void> _open(BuildContext context) async {
    switch (scanItem.type) {
      case QrCodeType.url:
        await _openLink(context);
        break;
      case QrCodeType.phone:
        await _callPhone(context);
        break;
      case QrCodeType.email:
        await _sendEmail(context);
        break;
      case QrCodeType.contact:
      case QrCodeType.wifi:
      case QrCodeType.text:
        break;
    }
  }

  Future<void> _openLink(BuildContext context) async {
    try {
      final uri = UrlUtils.normalizeUrl(scanItem.content);
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
          LoggerService.info('Successfully opened URL: ${scanItem.content}');
        } else {
          LoggerService.warning('Failed to launch URL: ${scanItem.content}');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to open URL'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        LoggerService.warning('Cannot launch URL: ${scanItem.content}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot open this URL. No browser found.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error opening URL', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open URL: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _callPhone(BuildContext context) async {
    try {
      String phoneNumber = scanItem.content;
      if (!phoneNumber.startsWith('tel:')) {
        phoneNumber = 'tel:$phoneNumber';
      }
      final uri = Uri.parse(phoneNumber);
      LoggerService.info('Attempting to call: $uri');

      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri);
        if (launched) {
          LoggerService.info(
            'Successfully initiated call: ${scanItem.content}',
          );
        } else {
          LoggerService.warning('Failed to initiate call: ${scanItem.content}');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to make call'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        LoggerService.warning('Cannot make call: ${scanItem.content}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot make call. No phone app found.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error making call', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to make call: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    try {
      String emailUri = scanItem.content;
      if (!emailUri.startsWith('mailto:')) {
        emailUri = 'mailto:$emailUri';
      }
      final uri = Uri.parse(emailUri);
      LoggerService.info('Attempting to send email: $uri');

      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        final launched = await launchUrl(uri);
        if (launched) {
          LoggerService.info('Successfully opened email: ${scanItem.content}');
        } else {
          LoggerService.warning('Failed to open email: ${scanItem.content}');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to open email'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        LoggerService.warning('Cannot open email: ${scanItem.content}');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot open email. No email app found.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error sending email', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send email: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addContact(BuildContext context) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Contact import feature is not available on this device',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      LoggerService.info('Contact import requested for: ${scanItem.content}');
    } catch (e) {
      LoggerService.error('Error adding contact', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add contact'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _connectToWifi(BuildContext context) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'WiFi connection feature is not available on this device',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
      LoggerService.info('WiFi connection requested for: ${scanItem.content}');
    } catch (e) {
      LoggerService.error('Error connecting to WiFi', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to connect to WiFi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: scanItem.content));
      LoggerService.info('Copied to clipboard: ${scanItem.content}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      LoggerService.error('Error copying to clipboard', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to copy'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _share(BuildContext context) async {
    try {
      String contentToShare = scanItem.content;

      if (scanItem.type == QrCodeType.wifi) {
        contentToShare = QrContentParser.formatWifiContent(scanItem.content);
      }

      await Share.share(contentToShare);
      LoggerService.info('Shared content: $contentToShare');

      final historyItem = ScanHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: scanItem.content,
        type: scanItem.type,
        action: ScanHistoryAction.shared,
        timestamp: DateTime.now(),
        title: HistoryTitleFormatter.formatTitle(
          ScanHistoryAction.shared,
          scanItem.type,
        ),
      );

      final firestoreService = FirestoreService();
      await firestoreService.addScanHistoryItem(historyItem);
      LoggerService.info('Added shared action to history');
    } catch (e) {
      LoggerService.error('Error sharing content', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _save(BuildContext context) async {
    try {
      final firestoreService = FirestoreService();
      final itemToSave = scanItem.copyWith(
        title:
            scanItem.title ??
            HistoryTitleFormatter.formatTitle(scanItem.action, scanItem.type),
      );
      await firestoreService.addScanHistoryItem(itemToSave);
      LoggerService.info('Saved scan result to history');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to history'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      LoggerService.error('Error saving scan result', error: e);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPrimaryAction = scanItem.type != QrCodeType.text;

    return Column(
      children: [
        if (hasPrimaryAction)
          ScanResultPrimaryAction(
            scanItem: scanItem,
            onOpen: () => _open(context),
            onAddContact: () => _addContact(context),
            onConnectToWifi: () => _connectToWifi(context),
          ),
        if (hasPrimaryAction) const SizedBox(height: 13),
        Builder(
          builder: (context) => Row(
            children: [
              Expanded(
                child: QrCodeAction(
                  icon: SvgPicture.asset(
                    'assets/icons/result_actions/copy_icon.svg',
                  ),
                  label: 'Copy',
                  onTap: () => _copyToClipboard(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QrCodeAction(
                  icon: SvgPicture.asset(
                    'assets/icons/result_actions/share_icon.svg',
                  ),
                  label: 'Share',
                  onTap: () => _share(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QrCodeAction(
                  icon: SvgPicture.asset(
                    'assets/icons/result_actions/save_icon.svg',
                  ),
                  label: 'Save',
                  onTap: () => _save(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
