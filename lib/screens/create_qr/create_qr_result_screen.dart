import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/firestore_service.dart';
import 'package:qr_master/services/image_service.dart';
import 'package:qr_master/services/logger_service.dart';
import 'package:qr_master/services/main_tabs_service.dart';
import 'package:qr_master/widgets/layouts/index.dart';
import 'package:qr_master/widgets/main_screen/index.dart';
import 'package:qr_master/widgets/ui/index.dart';
import 'package:share_plus/share_plus.dart';

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
      LoggerService.info('Sharing QR code');
      final xFile = XFile.fromData(
        widget.qrImage,
        mimeType: 'image/png',
        name: 'qr_code.png',
      );
      await Share.shareXFiles([xFile], text: 'QR Code');
      LoggerService.info('QR code shared successfully');
    } catch (e) {
      LoggerService.error('Error sharing QR code', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share QR code'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      LoggerService.info('Saving QR code to library');
      final saved = await ImageService.saveImageToGallery(widget.qrImage);

      if (!saved) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save QR code to gallery'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final qrCode = QrCode(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: widget.content,
        type: widget.type,
        createdAt: DateTime.now(),
        scanCount: 0,
      );

      final firestoreService = FirestoreService();
      await firestoreService.addCreatedQrCode(qrCode);

      LoggerService.info('QR code saved to library successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR code saved to library'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      LoggerService.error('Error saving QR code to library', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save QR code to library'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    return Scaffold(
      body: ScreenLayout(
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
                        child: Image.memory(
                          widget.qrImage,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 37),
                  Row(
                    children: [
                      Expanded(
                        child: QrCodeAction(
                          icon: SvgPicture.asset(
                            'assets/icons/result_actions/share_icon.svg',
                          ),
                          label: 'Share',
                          onTap: _shareQrCode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QrCodeAction(
                          icon: SvgPicture.asset(
                            'assets/icons/result_actions/save_icon.svg',
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
      ),
      bottomNavigationBar: BottomTabsNavigator(
        currentItem: BottomNavItem.create,
        onItemSelected: (item) => _handleTabSelected(context, item),
        onFabTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          MainTabsService().switchToCreate();
        },
      ),
    );
  }
}
