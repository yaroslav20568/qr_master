import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/index.dart';

class HistorySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const HistorySearchBar({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Search history...',
      onChanged: onChanged,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Icon(Icons.search, size: 20, color: AppColors.textDisabled),
      ),
    );
  }
}
