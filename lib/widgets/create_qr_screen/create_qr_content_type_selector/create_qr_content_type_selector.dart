import 'package:flutter/material.dart';
import 'package:qr_master/constants/app_assets.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/widgets/create_qr_screen/create_qr_content_type_selector/index.dart';
import 'package:qr_master/widgets/layouts/index.dart';

List<Map<String, dynamic>> _getContentTypes() {
  return [
    {
      'type': QrCodeType.url,
      'icon': '${AppAssets.iconsPath}content_type/url_icon.svg',
      'label': 'URL',
    },
    {
      'type': QrCodeType.text,
      'icon': '${AppAssets.iconsPath}content_type/text_icon.svg',
      'label': 'Text',
    },
    {
      'type': QrCodeType.contact,
      'icon': '${AppAssets.iconsPath}content_type/contact_icon.svg',
      'label': 'Contact',
    },
    {'type': QrCodeType.phone, 'icon': Icons.phone, 'label': 'Phone'},
    {'type': QrCodeType.email, 'icon': Icons.email, 'label': 'Email'},
    {
      'type': QrCodeType.wifi,
      'icon': '${AppAssets.iconsPath}content_type/wifi_icon.svg',
      'label': 'Wi-Fi',
    },
  ];
}

class CreateQrContentTypeSelector extends StatelessWidget {
  final QrCodeType selectedType;
  final ValueChanged<QrCodeType> onTypeSelected;

  const CreateQrContentTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  List<Widget> _buildButtonRow(int startIndex, int count) {
    final contentTypes = _getContentTypes();
    final widgets = <Widget>[];
    for (int i = 0; i < count; i++) {
      final itemIndex = startIndex + i;
      if (itemIndex >= contentTypes.length) break;

      final item = contentTypes[itemIndex];
      widgets.add(
        ContentTypeButton(
          type: item['type'] as QrCodeType,
          selectedType: selectedType,
          icon: item['icon'] as Object,
          label: item['label'] as String,
          onTap: () => onTypeSelected(item['type'] as QrCodeType),
        ),
      );

      if (i < count - 1) {
        widgets.add(const SizedBox(width: 12));
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Content Type',
      child: Column(
        children: [
          Row(children: _buildButtonRow(0, 3)),
          const SizedBox(height: 12),
          Row(children: _buildButtonRow(3, 3)),
        ],
      ),
    );
  }
}
