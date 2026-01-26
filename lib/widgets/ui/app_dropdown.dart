import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hintText;

  const AppDropdown({
    super.key,
    required this.label,
    this.value,
    required this.items,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            border: Border.all(color: AppColors.transparent, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              hint: hintText != null
                  ? Text(
                      hintText!,
                      style: AppFonts.interRegular.copyWith(
                        fontSize: 15,
                        letterSpacing: -0.5,
                        color: AppColors.textDisabled,
                      ),
                    )
                  : null,
              style: AppFonts.interRegular.copyWith(
                fontSize: 15,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
