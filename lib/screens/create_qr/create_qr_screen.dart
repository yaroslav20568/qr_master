import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/services/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/create_qr_screen/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class CreateQrScreen extends StatefulWidget {
  const CreateQrScreen({super.key});

  @override
  State<CreateQrScreen> createState() => _CreateQrScreenState();
}

class _CreateQrScreenState extends State<CreateQrScreen> {
  QrCodeType _selectedType = QrCodeType.url;
  Color _selectedColor = AppColors.dark;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final content = _getContent();
    LoggerService.info('Generating QR code for type: ${_selectedType.name}');

    try {
      final qrService = QrService();
      final qrImage = await qrService.generateQrCodeImage(
        data: content,
        size: 300,
        foregroundColor: _selectedColor,
        backgroundColor: AppColors.primaryBg,
      );

      if (qrImage != null && mounted) {
        Navigator.of(context).pushNamed(
          AppRoutes.createQrResult,
          arguments: {
            'qrImage': qrImage,
            'content': content,
            'type': _selectedType,
            'color': _selectedColor,
            'qrCodeName': _controllers['qrCodeName']?.text ?? '',
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to generate QR code'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      LoggerService.error('Error generating QR code', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleAddLogo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pro Feature - Coming soon'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      child: Center(
        child: SingleChildScrollView(
          child: PaddingLayout(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
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
                    onAddLogo: _handleAddLogo,
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
