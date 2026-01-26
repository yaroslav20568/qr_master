import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/index.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScanHistoryService _scanHistoryService = ScanHistoryService();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  ScanHistoryAction? _selectedAction;
  String _searchQuery = '';
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    AnalyticsService().logEvent(name: 'history_screen_viewed');
  }

  void _loadRewardedAd() {
    AdsService().loadRewardedAd(
      onAdLoaded: (ad) {
        setState(() {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
        });
        AnalyticsService().logEvent(name: 'rewarded_ad_loaded');
      },
      onAdFailedToLoad: (error) {
        LoggerService.warning('Rewarded ad failed to load: $error');
      },
    );
  }

  Future<void> _showRewardedAd() async {
    if (_rewardedAd == null || !_isRewardedAdLoaded) {
      SnackbarService.showWarning(context, message: 'Ad is not ready yet');
      return;
    }

    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdLoaded = false;
        _loadRewardedAd();
        AnalyticsService().logEvent(name: 'rewarded_ad_closed');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        _isRewardedAdLoaded = false;
        _loadRewardedAd();
        LoggerService.error('Rewarded ad failed to show', error: error);
      },
    );

    await _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        AnalyticsService().logEvent(
          name: 'rewarded_ad_reward_earned',
          parameters: {
            'reward_type': reward.type,
            'reward_amount': reward.amount,
          },
        );
        SnackbarService.showSuccess(context, message: 'Reward earned!');
      },
    );
    AnalyticsService().logEvent(name: 'rewarded_ad_shown');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      setState(() {
        _searchQuery = value.trim();
      });
    });
  }

  List<ScanHistoryItem> _filteredItems(List<ScanHistoryItem> items) {
    var filtered = items;

    if (_selectedAction != null) {
      filtered = filtered
          .where((item) => item.action == _selectedAction)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      filtered = filtered.where((item) {
        final content = item.content.toLowerCase();
        final displayContent = QrContentParser.getDisplayContent(
          item.content,
          item.type,
        ).toLowerCase();
        final title = item.title?.toLowerCase() ?? '';
        return content.contains(query) ||
            displayContent.contains(query) ||
            title.contains(query);
      }).toList();
    }

    return filtered;
  }

  void _onItemTap(ScanHistoryItem item) {
    Navigator.of(context).pushNamed(AppRoutes.scanResult, arguments: item);
  }

  Future<void> _onItemCopy(ScanHistoryItem item) async {
    try {
      await Clipboard.setData(ClipboardData(text: item.content));
      LoggerService.info('Copied to clipboard: ${item.content}');
      if (!mounted) return;
      SnackbarService.showSuccess(
        context,
        message: 'Copied to clipboard',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LoggerService.error('Error copying to clipboard', error: e);
      if (!mounted) return;
      SnackbarService.showError(context, message: 'Failed to copy');
    }
  }

  Future<void> _onItemShare(ScanHistoryItem item) async {
    try {
      final qrService = QrService();
      final qrImage = await qrService.generateQrCodeImage(
        data: item.content,
        size: 512,
        foregroundColor: item.color ?? AppColors.dark,
      );

      if (qrImage == null) {
        if (!mounted) return;
        SnackbarService.showError(
          context,
          message: 'Failed to generate QR code',
        );
        return;
      }

      if (!mounted) return;
      await QrCodeActionsService.shareQrCode(
        context,
        item.content,
        qrImage: qrImage,
      );

      if (item.action != ScanHistoryAction.shared) {
        final historyItem = ScanHistoryItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: item.content,
          type: item.type,
          action: ScanHistoryAction.shared,
          timestamp: DateTime.now(),
          title: HistoryTitleFormatter.formatTitle(
            ScanHistoryAction.shared,
            item.type,
          ),
          color: item.color,
        );

        await _scanHistoryService.addScanHistoryItem(historyItem);
        LoggerService.info('Added shared action to history');
      }
    } catch (e) {
      LoggerService.error('Error sharing QR code', error: e);
      if (!mounted) return;
      SnackbarService.showError(context, message: 'Failed to share');
    }
  }

  Future<void> _onItemDelete(ScanHistoryItem item) async {
    final confirmed = await ConfirmModal.show(
      context,
      title: 'Delete Item',
      text: 'Are you sure you want to delete this item?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmColor: AppColors.negative,
    );

    if (confirmed == true) {
      try {
        await _scanHistoryService.deleteScanHistoryItem(item.id);
        if (!mounted) return;
        SnackbarService.showSuccess(context, message: 'Item deleted');
      } catch (e) {
        LoggerService.error('Error deleting item', error: e);
        if (!mounted) return;
        SnackbarService.showError(context, message: 'Failed to delete item');
      }
    }
  }

  Future<void> _deleteAllHistory() async {
    if (!mounted) return;
    final confirmed = await ConfirmModal.show(
      context,
      title: 'Delete All History',
      text:
          'Are you sure you want to delete all history items? This action cannot be undone.',
      confirmText: 'Delete All',
      cancelText: 'Cancel',
      confirmColor: AppColors.negative,
    );

    if (confirmed == true) {
      try {
        await _scanHistoryService.deleteAllHistory();
        if (!mounted) return;
        SnackbarService.showSuccess(context, message: 'All history deleted');
        Navigator.of(context).pop();
      } catch (e) {
        LoggerService.error('Error deleting all history', error: e);
        if (!mounted) return;
        SnackbarService.showError(
          context,
          message: 'Failed to delete all history',
        );
      }
    }
  }

  void _showSearchModal() {
    BottomModal.show(
      context,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search history...',
          ),
          ListTile(
            leading: const Icon(Icons.clear, color: AppColors.textPrimary),
            title: Text(
              'Clear',
              style: AppFonts.interMedium.copyWith(
                fontSize: 15,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
            onTap: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outline,
              color: AppColors.negative,
            ),
            title: const Text('Delete All History'),
            onTap: _deleteAllHistory,
          ),
          ListTile(
            leading: const Icon(
              Icons.play_circle_outline,
              color: AppColors.primary,
            ),
            title: const Text('Watch Ad for Rewards'),
            onTap: () {
              Navigator.of(context).pop();
              _showRewardedAd();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'History',
      rightIcon: Icons.sort,
      onRightIconTap: _showSearchModal,
      headerContent: FilterChips<ScanHistoryAction>(
        items: const [
          ScanHistoryAction.scanned,
          ScanHistoryAction.created,
          ScanHistoryAction.shared,
        ],
        selectedItem: _selectedAction,
        onItemSelected: (action) {
          setState(() {
            _selectedAction = action;
          });
        },
        getLabel: (action) {
          switch (action) {
            case ScanHistoryAction.scanned:
              return 'Scanned';
            case ScanHistoryAction.created:
              return 'Created';
            case ScanHistoryAction.shared:
              return 'Shared';
          }
        },
      ),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ScanHistoryItem>>(
              stream: _scanHistoryService.getScanHistoryStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SingleChildScrollView(
                    child: PaddingLayout(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const CircularProgressIndicator()],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return SingleChildScrollView(
                    child: PaddingLayout(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const EmptyData(title: 'Error loading history'),
                        ],
                      ),
                    ),
                  );
                }

                final allItems = snapshot.data ?? [];
                final filteredItems = _filteredItems(allItems);

                if (filteredItems.isEmpty) {
                  return SingleChildScrollView(
                    child: PaddingLayout(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const EmptyData(title: 'No history items found'),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: PaddingLayout(
                      child: HistoryList(
                        items: filteredItems,
                        onItemTap: _onItemTap,
                        onItemDelete: _onItemDelete,
                        onItemCopy: _onItemCopy,
                        onItemShare: _onItemShare,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
