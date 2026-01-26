import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _incrementScanViewIfNeeded();
    _loadInterstitialAd();
    AnalyticsService().logEvent(name: 'scan_result_viewed');
  }

  void _loadInterstitialAd() {
    AdsService().loadInterstitialAd(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
        _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;
            AnalyticsService().logEvent(name: 'interstitial_ad_closed');
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;
            LoggerService.error('Interstitial ad failed to show', error: error);
          },
        );
        _interstitialAd?.show();
        AnalyticsService().logEvent(name: 'interstitial_ad_shown');
      },
      onAdFailedToLoad: (error) {
        LoggerService.warning('Interstitial ad failed to load: $error');
      },
    );
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
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
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
