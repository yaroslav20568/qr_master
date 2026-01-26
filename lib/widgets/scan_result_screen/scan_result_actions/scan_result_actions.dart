import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/scan_result_screen/scan_result_actions/scan_result_primary_action.dart';
import 'package:qr_master/widgets/ui/qr_code_action.dart';

class ScanResultActions extends StatelessWidget {
  final ScanHistoryItem scanItem;

  const ScanResultActions({super.key, required this.scanItem});

  Future<void> _open(BuildContext context) async {
    await QrCodeActionsService.openByType(
      context,
      scanItem.content,
      scanItem.type,
    );
  }

  Future<void> _addContact(BuildContext context) async {
    await QrCodeActionsService.addContact(context, scanItem.content);
  }

  Future<void> _connectToWifi(BuildContext context) async {
    await QrCodeActionsService.connectToWifi(context, scanItem.content);
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await QrCodeActionsService.copyContent(context, scanItem.content);
  }

  Future<void> _share(BuildContext context) async {
    try {
      final qrService = QrService();
      final qrImage = await qrService.generateQrCodeImage(
        data: scanItem.content,
        size: 512,
        foregroundColor: scanItem.color ?? AppColors.dark,
      );

      if (!context.mounted) return;
      await QrCodeActionsService.shareQrCode(
        context,
        scanItem.content,
        qrImage: qrImage,
      );

      if (scanItem.action != ScanHistoryAction.shared) {
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
          color: scanItem.color,
        );

        final scanHistoryService = ScanHistoryService();
        await scanHistoryService.addScanHistoryItem(historyItem);
        LoggerService.info('Added shared action to history');
      }
    } catch (e) {
      LoggerService.error('Error sharing content', error: e);
      if (context.mounted) {
        SnackbarService.showError(context, message: 'Failed to share');
      }
    }
  }

  Future<void> _save(BuildContext context) async {
    await QrCodeActionsService.saveToGallery(
      context,
      scanItem.content,
      foregroundColor: scanItem.color,
    );
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
                    '${AppAssets.iconsPath}result_actions/copy_icon.svg',
                  ),
                  label: 'Copy',
                  onTap: () => _copyToClipboard(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QrCodeAction(
                  icon: SvgPicture.asset(
                    '${AppAssets.iconsPath}result_actions/share_icon.svg',
                  ),
                  label: 'Share',
                  onTap: () => _share(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QrCodeAction(
                  icon: SvgPicture.asset(
                    '${AppAssets.iconsPath}result_actions/save_icon.svg',
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
