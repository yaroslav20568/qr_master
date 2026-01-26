import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/index.dart';

class CreateQrResultScreen extends StatefulWidget {
  final Uint8List qrImage;
  final String content;
  final QrCodeType type;
  final Color color;
  final String qrCodeName;

  const CreateQrResultScreen({
    super.key,
    required this.qrImage,
    required this.content,
    required this.type,
    required this.color,
    required this.qrCodeName,
  });

  @override
  State<CreateQrResultScreen> createState() => _CreateQrResultScreenState();
}

class _CreateQrResultScreenState extends State<CreateQrResultScreen> {
  bool _isSaving = false;
  bool _isSharing = false;

  Future<void> _shareQrCode() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      await QrCodeActionsService.shareQrCode(
        context,
        widget.content,
        qrImage: widget.qrImage,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _saveToLibrary() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await QrCodeActionsService.saveToGallery(
        context,
        widget.content,
        qrImage: widget.qrImage,
        foregroundColor: widget.color,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _handleTabSelected(BuildContext context, BottomNavItem item) {
    if (item == BottomNavItem.create) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      MainTabsService().switchToTabItem(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      title: 'Create QR Code',
      rightIcon: Icons.close,
      onRightIconTap: () => Navigator.of(context).pop(),
      iconColor: AppColors.dark,
      bottomNavigationBar: BottomTabsNavigator(
        currentItem: BottomNavItem.create,
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
                InfoIndicator(
                  title: 'The QR code is ready',
                  text: 'QR code name: ${widget.qrCodeName}',
                ),
                const SizedBox(height: 27),
                QrCodeLayout(
                  child: Center(
                    child: SizedBox(
                      width: 220,
                      height: 220,
                      child: Image.memory(widget.qrImage, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 37),
                Row(
                  children: [
                    Expanded(
                      child: QrCodeAction(
                        icon: SvgPicture.asset(
                          '${AppAssets.iconsPath}result_actions/share_icon.svg',
                        ),
                        label: 'Share',
                        onTap: _shareQrCode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QrCodeAction(
                        icon: SvgPicture.asset(
                          '${AppAssets.iconsPath}result_actions/save_icon.svg',
                        ),
                        label: 'Save',
                        onTap: _saveToLibrary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
