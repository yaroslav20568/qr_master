import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/index.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late MobileScannerController _controller;
  bool _isFlashOn = false;
  bool _isPermissionGranted = false;
  bool _isProcessing = false;
  bool _isScreenVisible = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _checkCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    final shouldBeVisible =
        (state == AppLifecycleState.resumed) && _isScreenVisible;
    _updateCameraState(shouldBeVisible);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null) {
        final isCurrent = route.isCurrent;
        if (isCurrent != _isScreenVisible) {
          setState(() {
            _isScreenVisible = isCurrent;
          });
          _updateCameraState(_isScreenVisible);
        }
      }
    });
  }

  void _updateCameraState(bool shouldBeActive) {
    if (!_isPermissionGranted) return;
    try {
      if (shouldBeActive) {
        _controller.start();
        LoggerService.info('Camera resumed');
      } else {
        _controller.stop();
        LoggerService.info('Camera paused');
      }
    } catch (e) {
      LoggerService.warning(
        'Error ${shouldBeActive ? "starting" : "stopping"} camera: $e',
      );
    }
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
    setState(() {
      _isFlashOn = false;
    });
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
        LoggerService.info('Image picked from gallery: ${image.path}');
        await _processImage(image.path);
      } else {
        LoggerService.info('No image selected from gallery');
      }
    } catch (e) {
      LoggerService.error('Error picking image from gallery', error: e);
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to pick image from gallery',
        );
      }
    }
  }

  Future<void> _processImage(String imagePath) async {
    if (_isProcessing) {
      LoggerService.warning('Already processing an image');
      return;
    }

    LoggerService.info('Processing image: $imagePath');

    setState(() {
      _isProcessing = true;
    });

    try {
      LoggerService.info('Starting image analysis...');
      final result = await _controller.analyzeImage(imagePath);

      LoggerService.info(
        'Image analysis completed. Result: ${result != null ? 'found' : 'null'}',
      );

      if (result != null && result.barcodes.isNotEmpty) {
        LoggerService.info('Found ${result.barcodes.length} barcode(s)');
        final barcode = result.barcodes.first;
        LoggerService.info(
          'Barcode type: ${barcode.type}, value: ${barcode.rawValue}',
        );

        if (barcode.rawValue != null) {
          setState(() {
            _isProcessing = false;
          });
          await _handleScanResult(barcode.rawValue!);
        } else {
          LoggerService.warning('Barcode found but rawValue is null');
          if (mounted) {
            SnackbarService.showWarning(
              context,
              message: 'QR code found but content is empty',
            );
          }
        }
      } else {
        LoggerService.warning('No QR code found in image');
        if (mounted) {
          SnackbarService.showWarning(
            context,
            message: 'No QR code found in image',
          );
        }
      }
    } catch (e, stackTrace) {
      LoggerService.error('Error processing image', error: e);
      LoggerService.error('Stack trace: $stackTrace');
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to process image: ${e.toString()}',
          duration: const Duration(seconds: 4),
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
    LoggerService.info('Handling scan result: $content');

    try {
      final qrService = QrService();
      final type = qrService.detectQrCodeType(content);
      LoggerService.info('Detected QR type: ${type.displayName}');

      final scanItem = ScanHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type,
        action: ScanHistoryAction.scanned,
        timestamp: DateTime.now(),
        title: HistoryTitleFormatter.formatTitle(
          ScanHistoryAction.scanned,
          type,
        ),
      );

      final scanHistoryService = ScanHistoryService();
      await scanHistoryService.addScanHistoryItem(scanItem);
      LoggerService.info('Saved scanned item to history');

      LoggerService.info('Created scan item, navigating to result screen...');

      if (!mounted) {
        LoggerService.warning('Widget not mounted, cannot navigate');
        return;
      }

      LoggerService.info('Navigating to Scan Result Screen');
      await Navigator.of(
        context,
      ).pushNamed(AppRoutes.scanResult, arguments: scanItem);
      LoggerService.info('Navigation completed');
    } catch (e, stackTrace) {
      LoggerService.error('Error handling scan result', error: e);
      LoggerService.error('Stack trace: $stackTrace');
      if (mounted) {
        SnackbarService.showError(
          context,
          message: 'Failed to process scan result: ${e.toString()}',
          duration: const Duration(seconds: 4),
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
    super.build(context);
    return ScreenLayout(
      title: 'Scan QR Code',
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
