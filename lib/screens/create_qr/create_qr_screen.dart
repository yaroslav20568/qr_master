import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/index.dart';

class CreateQrScreen extends StatefulWidget {
  const CreateQrScreen({super.key});

  @override
  State<CreateQrScreen> createState() => _CreateQrScreenState();
}

class _CreateQrScreenState extends State<CreateQrScreen> {
  final MainTabsService _tabsService = MainTabsService();
  QrCodeType _selectedType = QrCodeType.url;
  Color _selectedColor = AppColors.black;
  final Map<String, TextEditingController> _controllers = {};
  RewardedInterstitialAd? _rewardedInterstitialAd;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadRewardedInterstitialAd();
    AnalyticsService().logEvent(name: 'create_qr_screen_viewed');
  }

  void _loadRewardedInterstitialAd() {
    AdsService().loadRewardedInterstitialAd(
      onAdLoaded: (ad) {
        _rewardedInterstitialAd = ad;
        AnalyticsService().logEvent(name: 'rewarded_interstitial_ad_loaded');
      },
      onAdFailedToLoad: (error) {
        LoggerService.warning(
          'Rewarded interstitial ad failed to load: $error',
        );
      },
    );
  }

  void _initializeControllers() {
    _controllers['url'] = TextEditingController();
    _controllers['text'] = TextEditingController();
    _controllers['phone'] = TextEditingController();
    _controllers['email'] = TextEditingController();
    _controllers['contactName'] = TextEditingController();
    _controllers['contactPhone'] = TextEditingController();
    _controllers['contactEmail'] = TextEditingController();
    _controllers['wifiSsid'] = TextEditingController();
    _controllers['wifiPassword'] = TextEditingController();
    _controllers['wifiEncryptionType'] = TextEditingController(text: 'WPA');
    _controllers['qrCodeName'] = TextEditingController();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _rewardedInterstitialAd?.dispose();
    super.dispose();
  }

  String _getContent() {
    switch (_selectedType) {
      case QrCodeType.url:
        return QrContentFormatter.formatContentForQr(
          _controllers['url']?.text ?? '',
          QrCodeType.url,
        );
      case QrCodeType.text:
        return _controllers['text']?.text ?? '';
      case QrCodeType.phone:
        return QrContentFormatter.formatContentForQr(
          _controllers['phone']?.text ?? '',
          QrCodeType.phone,
        );
      case QrCodeType.email:
        return QrContentFormatter.formatContentForQr(
          _controllers['email']?.text ?? '',
          QrCodeType.email,
        );
      case QrCodeType.contact:
        return QrContentFormatter.formatContactContent(
          name: _controllers['contactName']?.text ?? '',
          phone: _controllers['contactPhone']?.text,
          email: _controllers['contactEmail']?.text,
        );
      case QrCodeType.wifi:
        return QrContentFormatter.formatWifiContent(
          ssid: _controllers['wifiSsid']?.text ?? '',
          password: _controllers['wifiPassword']?.text ?? '',
          type: _controllers['wifiEncryptionType']?.text ?? 'WPA',
        );
    }
  }

  bool _isContentValid() {
    final content = _getContent();
    if (content.isEmpty) return false;

    switch (_selectedType) {
      case QrCodeType.url:
        if (_controllers['url']?.text.trim().isEmpty ?? true) return false;
        break;
      case QrCodeType.text:
        if (_controllers['text']?.text.trim().isEmpty ?? true) return false;
        break;
      case QrCodeType.phone:
        if (_controllers['phone']?.text.trim().isEmpty ?? true) return false;
        break;
      case QrCodeType.email:
        if (_controllers['email']?.text.trim().isEmpty ?? true) return false;
        break;
      case QrCodeType.contact:
        if (_controllers['contactName']?.text.trim().isEmpty ?? true) {
          return false;
        }
        break;
      case QrCodeType.wifi:
        if (_controllers['wifiSsid']?.text.trim().isEmpty ?? true) return false;
        break;
    }

    if (_controllers['qrCodeName']?.text.trim().isEmpty ?? true) return false;

    return true;
  }

  Future<void> _generateQrCode() async {
    if (!_isContentValid()) {
      SnackbarService.showWarning(
        context,
        message: 'Please fill in all required fields',
      );
      return;
    }

    final content = _getContent();
    final qrCodeName = _controllers['qrCodeName']?.text ?? '';
    LoggerService.info('Generating QR code for type: ${_selectedType.name}');

    try {
      final qrService = QrService();
      final qrImage = await qrService.generateQrCodeImage(
        data: content,
        size: 512,
        foregroundColor: _selectedColor,
      );

      if (qrImage != null && mounted) {
        final qrCodeId = DateTime.now().millisecondsSinceEpoch.toString();

        final qrCode = QrCode(
          id: qrCodeId,
          content: content,
          type: _selectedType,
          createdAt: DateTime.now(),
          title: qrCodeName.isNotEmpty ? qrCodeName : null,
          scanView: 0,
          color: _selectedColor,
        );

        final qrCodeService = QrCodeService();
        final scanHistoryService = ScanHistoryService();
        await qrCodeService.addCreatedQrCode(qrCode);

        final historyItem = ScanHistoryItem(
          id: qrCodeId,
          content: content,
          type: _selectedType,
          action: ScanHistoryAction.created,
          timestamp: DateTime.now(),
          title: HistoryTitleFormatter.formatTitle(
            ScanHistoryAction.created,
            _selectedType,
          ),
          color: _selectedColor,
        );
        await scanHistoryService.addScanHistoryItem(historyItem);

        if (!mounted) return;

        AnalyticsService().logEvent(
          name: 'qr_code_created',
          parameters: {'type': _selectedType.name},
        );

        _showRewardedInterstitialAd();

        Navigator.of(context).pushNamed(
          AppRoutes.createQrResult,
          arguments: {
            'qrImage': qrImage,
            'content': content,
            'type': _selectedType,
            'color': _selectedColor,
            'qrCodeName': qrCodeName,
          },
        );
        _resetFields();
      } else {
        if (mounted) {
          SnackbarService.showError(
            context,
            message: 'Failed to generate QR code',
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error generating QR code', error: e);
      if (mounted) {
        SnackbarService.showError(context, message: 'Error: ${e.toString()}');
      }
    }
  }

  void _showRewardedInterstitialAd() {
    if (_rewardedInterstitialAd == null) {
      _loadRewardedInterstitialAd();
      return;
    }

    _rewardedInterstitialAd
        ?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        _loadRewardedInterstitialAd();
        AnalyticsService().logEvent(name: 'rewarded_interstitial_ad_closed');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedInterstitialAd = null;
        _loadRewardedInterstitialAd();
        LoggerService.error(
          'Rewarded interstitial ad failed to show',
          error: error,
        );
      },
    );

    _rewardedInterstitialAd?.show(
      onUserEarnedReward: (ad, reward) {
        AnalyticsService().logEvent(
          name: 'rewarded_interstitial_ad_reward_earned',
          parameters: {
            'reward_type': reward.type,
            'reward_amount': reward.amount,
          },
        );
      },
    );
    AnalyticsService().logEvent(name: 'rewarded_interstitial_ad_shown');
  }

  void _resetFields() {
    setState(() {
      _selectedType = QrCodeType.url;
      _selectedColor = AppColors.black;
      for (final controller in _controllers.values) {
        controller.clear();
      }
      _controllers['wifiEncryptionType']?.text = 'WPA';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Create QR Code',
      rightIcon: Icons.close,
      iconColor: AppColors.dark,
      onRightIconTap: () => _tabsService.switchToHome(),
      child: Center(
        child: SingleChildScrollView(
          child: PaddingLayout(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreateQrContentTypeSelector(
                  selectedType: _selectedType,
                  onTypeSelected: (type) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                ),
                const SizedBox(height: 41),
                CreateQrFormInputs(
                  type: _selectedType,
                  controllers: _controllers,
                  showQrCodeNameField: true,
                ),
                const SizedBox(height: 18),
                SectionLayout(
                  title: 'Design Options',
                  child: CreateQrDesignOptions(
                    selectedColor: _selectedColor,
                    onColorSelected: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Button(text: 'Generate QR Code', onPressed: _generateQrCode),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
