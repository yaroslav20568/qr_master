import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class ScanResultScreen extends StatefulWidget {
  final ScanHistoryItem? scanItem;

  const ScanResultScreen({super.key, this.scanItem});

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  final QrCodeService _qrCodeService = QrCodeService();

  @override
  void initState() {
    super.initState();
    _incrementScanViewIfNeeded();
  }

  Future<void> _incrementScanViewIfNeeded() async {
    if (widget.scanItem == null) return;

    if (widget.scanItem!.action == ScanHistoryAction.created) {
      try {
        await _qrCodeService.updateQrCodeScanView(widget.scanItem!.id);
        LoggerService.info(
          'Scan view incremented for QR code: ${widget.scanItem!.id}',
        );
      } catch (e) {
        LoggerService.error('Error incrementing scan view', error: e);
      }
    }
  }

  void _handleTabSelected(BuildContext context, BottomNavItem item) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    MainTabsService().switchToTabItem(item);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Scan Result',
      rightIcon: Icons.close,
      iconColor: AppColors.dark,
      onRightIconTap: () => Navigator.of(context).pop(),
      bottomNavigationBar: BottomTabsNavigator(
        currentItem: BottomNavItem.scan,
        onItemSelected: (item) => _handleTabSelected(context, item),
        onFabTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          MainTabsService().switchToCreate();
        },
      ),
      child: Center(
        child: SingleChildScrollView(
          child: PaddingLayout(
            child: Column(
              children: [
                const InfoIndicator(
                  title: 'Scan Successful',
                  text: 'QR code decoded successfully',
                ),
                const SizedBox(height: 21),
                ScanResultCard(scanItem: widget.scanItem!),
                const SizedBox(height: 21),
                ScanResultActions(scanItem: widget.scanItem!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
