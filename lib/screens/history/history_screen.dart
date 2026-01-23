import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/index.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  ScanHistoryAction? _selectedAction;
  String _searchQuery = '';
  List<ScanHistoryItem> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await _firestoreService.getScanHistory(limit: 200);
      setState(() {
        _allItems = items;
        _isLoading = false;
      });
    } catch (e) {
      LoggerService.error('Error loading history', error: e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<ScanHistoryItem> get _filteredItems {
    var items = _allItems;

    if (_selectedAction != null) {
      items = items.where((item) => item.action == _selectedAction).toList();
    }

    if (_searchQuery.isNotEmpty) {
      items = items.where((item) {
        final content = item.content.toLowerCase();
        final displayContent = QrContentParser.getDisplayContent(
          item.content,
          item.type,
        ).toLowerCase();
        return content.contains(_searchQuery) ||
            displayContent.contains(_searchQuery);
      }).toList();
    }

    return items;
  }

  void _onItemTap(ScanHistoryItem item) {
    Navigator.of(context).pushNamed(AppRoutes.scanResult, arguments: item);
  }

  void _onRescan() {
    MainTabsService().switchToScan();
  }

  Future<void> _onItemCopy(ScanHistoryItem item) async {
    try {
      await Clipboard.setData(ClipboardData(text: item.content));
      LoggerService.info('Copied to clipboard: ${item.content}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      LoggerService.error('Error copying to clipboard', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to copy'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onItemShare(ScanHistoryItem item) async {
    try {
      final qrService = QrService();
      final qrImage = await qrService.generateQrCodeImage(
        data: item.content,
        size: 512,
      );

      if (qrImage == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate QR code'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      String contentToShare = item.content;
      if (item.type == QrCodeType.wifi) {
        contentToShare = QrContentParser.formatWifiContent(item.content);
      }

      final xFile = XFile.fromData(
        qrImage,
        mimeType: 'image/png',
        name: 'qr_code.png',
      );
      await Share.shareXFiles([xFile], text: contentToShare);
      LoggerService.info('Shared QR code: ${item.content}');
    } catch (e) {
      LoggerService.error('Error sharing QR code', error: e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to share'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _onItemDelete(ScanHistoryItem item) async {
    final confirmed = await ConfirmModal.show(
      context,
      title: 'Delete Item',
      text: 'Are you sure you want to delete this item?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirmed == true) {
      try {
        await _firestoreService.deleteScanHistoryItem(item.id);
        await _loadHistory();
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Item deleted')));
      } catch (e) {
        LoggerService.error('Error deleting item', error: e);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete item')));
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
      confirmColor: Colors.red,
    );

    if (confirmed == true) {
      try {
        await _firestoreService.deleteAllHistory();
        await _loadHistory();
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('All history deleted')));
      } catch (e) {
        LoggerService.error('Error deleting all history', error: e);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete all history')),
        );
      }
    }
  }

  void _showDeleteAllDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete All History'),
              onTap: () {
                Navigator.of(context).pop();
                _deleteAllHistory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: Column(
        children: [
          PaddingLayout(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  'History',
                  style: AppFonts.interBold.copyWith(
                    fontSize: 34,
                    height: 1.5,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: HistorySearchBar(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    if (_allItems.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => _showDeleteAllDialog(context),
                        tooltip: 'Delete all',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                HistoryFilterChips(
                  selectedAction: _selectedAction,
                  onActionSelected: (action) {
                    setState(() {
                      _selectedAction = action;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadHistory,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: PaddingLayout(
                        child: HistoryList(
                          items: _filteredItems,
                          onItemTap: _onItemTap,
                          onItemDelete: _onItemDelete,
                          onItemRescan: _onRescan,
                          onItemCopy: _onItemCopy,
                          onItemShare: _onItemShare,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
