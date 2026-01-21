import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';
import 'package:qr_master/widgets/scan_screen/index.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late MobileScannerController _controller;
  bool _isFlashOn = false;
  bool _isPermissionGranted = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _checkCameraPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      final result = await Permission.camera.request();
      setState(() {
        _isPermissionGranted = result.isGranted;
      });
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _controller.toggleTorch();
  }

  void _switchCamera() {
    _controller.switchCamera();
  }

  Future<void> _openGallery() async {
    try {
      final imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image != null && mounted) {
        _processImage(image.path);
      }
    } catch (e) {
      LoggerService.error('Error picking image from gallery', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image from gallery'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _processImage(String imagePath) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await _controller.analyzeImage(imagePath);
      if (result != null && result.barcodes.isNotEmpty) {
        final barcode = result.barcodes.first;
        if (barcode.rawValue != null) {
          await _handleScanResult(barcode.rawValue!);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No QR code found in image'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      LoggerService.error('Error processing image', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleScanResult(String content) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final qrService = QrService();
      final type = qrService.detectQrCodeType(content);

      final scanItem = ScanHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type,
        action: ScanHistoryAction.scanned,
        timestamp: DateTime.now(),
      );

      final firestoreService = FirestoreService();
      await firestoreService.addScanHistoryItem(scanItem);

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushNamed(AppRoutes.scanResult, arguments: scanItem);
    } catch (e) {
      LoggerService.error('Error handling scan result', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process scan result'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      backgroundColor: AppColors.secondaryBg,
      child: Center(
        child: SingleChildScrollView(
          child: PaddingLayout(
            child: Column(
              children: [
                const ScanInfoBanner(),
                const SizedBox(height: 40),
                _isPermissionGranted
                    ? ScanCameraViewfinder(
                        cameraWidget: MobileScanner(
                          controller: _controller,
                          onDetect: (capture) {
                            if (_isProcessing) return;
                            final barcode = capture.barcodes.firstOrNull;
                            if (barcode?.rawValue != null) {
                              _handleScanResult(barcode!.rawValue!);
                            }
                          },
                        ),
                      )
                    : const ScanCameraViewfinder(),
                const SizedBox(height: 40),
                ScanCameraControls(
                  isFlashOn: _isFlashOn,
                  onFlashTap: _toggleFlash,
                  onSwitchCameraTap: _switchCamera,
                  onGalleryTap: _openGallery,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
