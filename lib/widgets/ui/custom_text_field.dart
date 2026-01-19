import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? initialValue;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool disabled;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.initialValue,
    this.suffixIcon,
    this.onChanged,
    this.keyboardType,
    this.controller,
    this.disabled = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.caption.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.44,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primaryBg,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(
              color: _isFocused ? AppColors.primary : Colors.transparent,
              width: _isFocused ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  enabled: !widget.disabled,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTextStyles.body.copyWith(
                      fontSize: 15,
                      color: AppColors.textDisabled,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              if (widget.suffixIcon != null) widget.suffixIcon!,
            ],
          ),
        ),
      ],
    );
  }
}
