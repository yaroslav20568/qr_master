import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';
import 'package:qr_master/utils/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class MyQrCodesList extends StatelessWidget {
  final List<QrCode> qrCodes;
  final Function(QrCode) onItemTap;
  final Function(QrCode)? onItemShare;
  final Function(QrCode)? onItemDelete;

  const MyQrCodesList({
    super.key,
    required this.qrCodes,
    required this.onItemTap,
    this.onItemShare,
    this.onItemDelete,
  });

  Widget _buildQrCodeCard(QrCode qrCode) {
    final actions = <ActionsDropdownItem>[];

    if (onItemShare != null) {
      actions.add(
        ActionsDropdownItem(
          icon: Icons.share,
          title: 'Share',
          onTap: () => onItemShare!(qrCode),
        ),
      );
    }

    if (onItemDelete != null) {
      actions.add(
        ActionsDropdownItem(
          icon: Icons.delete_outline,
          title: 'Delete',
          onTap: () => onItemDelete!(qrCode),
          iconColor: AppColors.negative,
          textColor: AppColors.negative,
        ),
      );
    }

    return QrCard(
      title: qrCode.title ?? qrCode.type.displayName,
      subtitle: qrCode.content,
      date: AppDateUtils.formatDate(qrCode.createdAt),
      views: '${qrCode.scanView}',
      size: QrCardSize.l,
      showMoreIcon: actions.isNotEmpty,
      onTap: () => onItemTap(qrCode),
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (qrCodes.isEmpty) {
      return const EmptyData(title: 'No QR codes found');
    }

    return Column(
      children: [
        for (int i = 0; i < qrCodes.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.5),
                  child: _buildQrCodeCard(qrCodes[i]),
                ),
              ),
              if (i + 1 < qrCodes.length)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.5),
                    child: _buildQrCodeCard(qrCodes[i + 1]),
                  ),
                )
              else
                Expanded(flex: 1, child: const SizedBox()),
            ],
          ),
          if (i + 2 < qrCodes.length) const SizedBox(height: 11),
        ],
      ],
    );
  }
}
