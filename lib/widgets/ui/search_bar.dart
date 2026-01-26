import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/widgets/ui/custom_text_field.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const AppSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomTextField(
        controller: controller,
        hintText: hintText,
        onChanged: onChanged,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.search, size: 20, color: AppColors.textDisabled),
        ),
      ),
    );
  }
}
