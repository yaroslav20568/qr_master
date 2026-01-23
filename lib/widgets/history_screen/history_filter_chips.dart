import 'package:flutter/material.dart';
import 'package:qr_master/constants/index.dart';
import 'package:qr_master/models/index.dart';

class HistoryFilterChips extends StatelessWidget {
  final ScanHistoryAction? selectedAction;
  final ValueChanged<ScanHistoryAction?> onActionSelected;

  const HistoryFilterChips({
    super.key,
    this.selectedAction,
    required this.onActionSelected,
  });

  static const List<ScanHistoryAction> _actions = [
    ScanHistoryAction.scanned,
    ScanHistoryAction.created,
  ];

  String _getActionLabel(ScanHistoryAction? action) {
    if (action == null) return 'All';
    switch (action) {
      case ScanHistoryAction.scanned:
        return 'Scanned';
      case ScanHistoryAction.created:
        return 'Created';
      case ScanHistoryAction.shared:
        return 'Shared';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('All', null),
          const SizedBox(width: 8),
          ..._actions.map(
            (action) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(_getActionLabel(action), action),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, ScanHistoryAction? action) {
    final isSelected = selectedAction == action;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onActionSelected(selected ? action : null);
      },
      selectedColor: AppColors.primary,
      checkmarkColor: AppColors.primaryBg,
      labelStyle: AppFonts.interMedium.copyWith(
        fontSize: 14,
        letterSpacing: -0.5,
        color: isSelected ? AppColors.primaryBg : AppColors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 1,
        ),
      ),
    );
  }
}
