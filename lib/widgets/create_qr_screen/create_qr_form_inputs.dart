import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class CreateQrFormInputs extends StatefulWidget {
  final QrCodeType type;
  final Map<String, TextEditingController> controllers;
  final ValueChanged<String>? onContentChanged;
  final bool showQrCodeNameField; // новый параметр

  const CreateQrFormInputs({
    super.key,
    required this.type,
    required this.controllers,
    this.onContentChanged,
    this.showQrCodeNameField = false, // по умолчанию false
  });

  @override
  State<CreateQrFormInputs> createState() => _CreateQrFormInputsState();
}

class _CreateQrFormInputsState extends State<CreateQrFormInputs> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (widget.showQrCodeNameField) {
      children.addAll([
        CustomTextField(
          label: 'QR Code Name',
          hintText: 'Enter name for your QR code',
          controller: widget.controllers['qrCodeName'],
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16),
      ]);
    }

    switch (widget.type) {
      case QrCodeType.url:
        children.add(_buildUrlInput());
        break;
      case QrCodeType.text:
        children.add(_buildTextInput());
        break;
      case QrCodeType.phone:
        children.add(_buildPhoneInput());
        break;
      case QrCodeType.email:
        children.add(_buildEmailInput());
        break;
      case QrCodeType.contact:
        children.add(_buildContactInputs());
        break;
      case QrCodeType.wifi:
        children.add(_buildWifiInputs());
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildUrlInput() {
    return CustomTextField(
      label: 'Website URL',
      hintText: 'https://example.com',
      controller: widget.controllers['url'],
      keyboardType: TextInputType.url,
      suffixIcon: GestureDetector(
        onTap: () async {
          final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
          if (clipboardData?.text != null &&
              widget.controllers['url'] != null) {
            widget.controllers['url']!.text = clipboardData!.text!;
            widget.controllers['url']!.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controllers['url']!.text.length),
            );
            widget.onContentChanged?.call(clipboardData.text!);
          }
        },
        child: SvgPicture.asset(
          'assets/icons/link_icon.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.grayMiddle,
            BlendMode.srcIn,
          ),
        ),
      ),
      onChanged: widget.onContentChanged,
    );
  }

  Widget _buildTextInput() {
    return CustomTextField(
      label: 'Text Content',
      hintText: 'Enter your text',
      controller: widget.controllers['text'],
      keyboardType: TextInputType.multiline,
      onChanged: widget.onContentChanged,
    );
  }

  Widget _buildPhoneInput() {
    return CustomTextField(
      label: 'Phone Number',
      hintText: '+1234567890',
      controller: widget.controllers['phone'],
      keyboardType: TextInputType.phone,
      onChanged: widget.onContentChanged,
    );
  }

  Widget _buildEmailInput() {
    return CustomTextField(
      label: 'Email Address',
      hintText: 'example@email.com',
      controller: widget.controllers['email'],
      keyboardType: TextInputType.emailAddress,
      onChanged: widget.onContentChanged,
    );
  }

  Widget _buildContactInputs() {
    return Column(
      children: [
        CustomTextField(
          label: 'Name',
          hintText: 'John Doe',
          controller: widget.controllers['contactName'],
          keyboardType: TextInputType.name,
          onChanged: widget.onContentChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Phone',
          hintText: '+1234567890',
          controller: widget.controllers['contactPhone'],
          keyboardType: TextInputType.phone,
          onChanged: widget.onContentChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Email',
          hintText: 'example@email.com',
          controller: widget.controllers['contactEmail'],
          keyboardType: TextInputType.emailAddress,
          onChanged: widget.onContentChanged,
        ),
      ],
    );
  }

  Widget _buildWifiInputs() {
    return Column(
      children: [
        CustomTextField(
          label: 'Network Name (SSID)',
          hintText: 'Wi-Fi Network',
          controller: widget.controllers['wifiSsid'],
          keyboardType: TextInputType.text,
          onChanged: widget.onContentChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Password',
          hintText: 'Enter password',
          controller: widget.controllers['wifiPassword'],
          keyboardType: TextInputType.visiblePassword,
          onChanged: widget.onContentChanged,
        ),
        const SizedBox(height: 16),
        _buildEncryptionTypeDropdown(),
      ],
    );
  }

  Widget _buildEncryptionTypeDropdown() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encryption Type',
              style: AppFonts.interMedium.copyWith(
                fontSize: 13,
                letterSpacing: -0.44,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.transparent, width: 1),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value:
                      widget.controllers['wifiEncryptionType']?.text ?? 'WPA',
                  isExpanded: true,
                  style: AppFonts.interRegular.copyWith(
                    fontSize: 15,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'WPA', child: Text('WPA')),
                    DropdownMenuItem(value: 'WEP', child: Text('WEP')),
                    DropdownMenuItem(
                      value: 'nopass',
                      child: Text('No encryption'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null &&
                        widget.controllers['wifiEncryptionType'] != null) {
                      setState(() {
                        widget.controllers['wifiEncryptionType']!.text = value;
                      });
                      widget.onContentChanged?.call(value);
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
