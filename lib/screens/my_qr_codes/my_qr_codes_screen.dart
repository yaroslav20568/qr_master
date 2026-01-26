import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/index.dart';

class MyQrCodesScreen extends StatefulWidget {
  const MyQrCodesScreen({super.key});

  @override
  State<MyQrCodesScreen> createState() => _MyQrCodesScreenState();
}

class _MyQrCodesScreenState extends State<MyQrCodesScreen> {
  final QrCodeService _qrCodeService = QrCodeService();
  final ScanHistoryService _scanHistoryService = ScanHistoryService();
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  String _searchQuery = '';
  QrCodeType? _selectedType;

  List<QrCode> _filteredQrCodes(List<QrCode> qrCodes) {
    var filtered = qrCodes;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      filtered = filtered.where((qrCode) {
        final title = qrCode.title?.toLowerCase() ?? '';
        final content = qrCode.content.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    }

    if (_selectedType != null) {
      filtered = filtered
          .where((qrCode) => qrCode.type == _selectedType)
          .toList();
    }

    return filtered;
  }

  void _onItemTap(QrCode qrCode) {
    final scanItem = ScanHistoryItem(
      id: qrCode.id,
      content: qrCode.content,
      type: qrCode.type,
      action: ScanHistoryAction.created,
      timestamp: qrCode.createdAt,
      title:
          qrCode.title ??
          HistoryTitleFormatter.formatTitle(
            ScanHistoryAction.created,
            qrCode.type,
          ),
      color: qrCode.color,
    );

    Navigator.of(context).pushNamed(AppRoutes.scanResult, arguments: scanItem);
  }

  Future<void> _onItemShare(QrCode qrCode) async {
    try {
      final qrService = QrService();
      final qrImage = await qrService.generateQrCodeImage(
        data: qrCode.content,
        size: 512,
        foregroundColor: qrCode.color,
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
        qrCode.content,
        qrImage: qrImage,
      );

      final historyItem = ScanHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: qrCode.content,
        type: qrCode.type,
        action: ScanHistoryAction.shared,
        timestamp: DateTime.now(),
        title: HistoryTitleFormatter.formatTitle(
          ScanHistoryAction.shared,
          qrCode.type,
        ),
      );

      await _scanHistoryService.addScanHistoryItem(historyItem);
      LoggerService.info('Added shared action to history');
    } catch (e) {
      LoggerService.error('Error sharing QR code', error: e);
      if (!mounted) return;
      SnackbarService.showError(context, message: 'Failed to share');
    }
  }

  Future<void> _onItemDelete(QrCode qrCode) async {
    final confirmed = await ConfirmModal.show(
      context,
      title: 'Delete QR Code',
      text: 'Are you sure you want to delete this QR code?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      confirmColor: AppColors.negative,
    );

    if (confirmed == true) {
      try {
        await _qrCodeService.deleteCreatedQrCode(qrCode.id);
        LoggerService.info('QR code deleted: ${qrCode.id}');
        if (!mounted) return;
        SnackbarService.showSuccess(context, message: 'QR code deleted');
      } catch (e) {
        LoggerService.error('Error deleting QR code', error: e);
        if (!mounted) return;
        SnackbarService.showError(context, message: 'Failed to delete QR code');
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debouncer.run(() {
      setState(() {
        _searchQuery = value.trim();
      });
    });
  }

  void _showSearchModal() {
    BottomModal.show(
      context,
      content: Column(
        children: [
          AppSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Search QR codes...',
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'My QR Codes',
      rightIcon: Icons.search,
      onRightIconTap: _showSearchModal,
      headerContent: FilterChips<QrCodeType>(
        items: const [
          QrCodeType.url,
          QrCodeType.text,
          QrCodeType.wifi,
          QrCodeType.contact,
        ],
        selectedItem: _selectedType,
        onItemSelected: (type) {
          setState(() {
            _selectedType = type;
          });
        },
        getLabel: (type) => type.displayName,
      ),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<QrCode>>(
              stream: _qrCodeService.getCreatedQrCodesStream(),
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
                          const EmptyData(title: 'Error loading QR codes'),
                        ],
                      ),
                    ),
                  );
                }

                final qrCodes = snapshot.data ?? [];
                final filteredQrCodes = _filteredQrCodes(qrCodes);

                if (filteredQrCodes.isEmpty) {
                  return SingleChildScrollView(
                    child: PaddingLayout(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [const EmptyData(title: 'No QR codes found')],
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
                      child: Column(
                        children: [
                          MyQrCodesList(
                            qrCodes: filteredQrCodes,
                            onItemTap: _onItemTap,
                            onItemShare: _onItemShare,
                            onItemDelete: _onItemDelete,
                          ),
                        ],
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
