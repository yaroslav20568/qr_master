import 'package:flutter/material.dart';

import 'chip_button.dart'; // Импортируем наш новый виджет

class FilterChips<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onItemSelected;
  final String Function(T) getLabel;
  final String allLabel;

  const FilterChips({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onItemSelected,
    required this.getLabel,
    this.allLabel = 'All',
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ChipButton(
            label: allLabel,
            isSelected: selectedItem == null,
            onTap: () => onItemSelected(null),
          ),
          const SizedBox(width: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ChipButton(
                label: getLabel(item),
                isSelected: selectedItem == item,
                onTap: () => onItemSelected(item),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
