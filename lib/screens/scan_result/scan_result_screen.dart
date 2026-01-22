import 'package:flutter/material.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanHistoryItem? scanItem;

  const ScanResultScreen({super.key, this.scanItem});

  void _handleTabSelected(BuildContext context, BottomNavItem item) {
    if (item == BottomNavItem.scan) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      MainTabsService().switchToTabItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenLayout(
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
                  ScanResultCard(scanItem: scanItem!),
                  const SizedBox(height: 21),
                  ScanResultActions(scanItem: scanItem!),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomTabsNavigator(
        currentItem: BottomNavItem.scan,
        onItemSelected: (item) => _handleTabSelected(context, item),
        onFabTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          MainTabsService().switchToCreate();
        },
      ),
    );
  }
}
