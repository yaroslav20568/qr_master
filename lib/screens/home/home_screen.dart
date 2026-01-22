import 'package:flutter/material.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/home_screen/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MainTabsService _tabsService = MainTabsService();

  void _onActivityItemTap(ScanHistoryItem item) {
    _tabsService.switchToHistory();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: SingleChildScrollView(
        child: PaddingLayout(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(userName: UserUtils.getUserDisplayName()),
              const SizedBox(height: 29),
              ActionCards(
                onScanTap: () => _tabsService.switchToScan(),
                onCreateTap: () => _tabsService.switchToCreate(),
                onMyQrCodesTap: () => _tabsService.switchToMyQrCodes(),
                onHistoryTap: () => _tabsService.switchToHistory(),
              ),
              const SizedBox(height: 32),
              RecentActivity(onItemTap: _onActivityItemTap),
            ],
          ),
        ),
      ),
    );
  }
}
