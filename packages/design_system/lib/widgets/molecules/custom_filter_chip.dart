import 'package:flutter/material.dart';

import '../../design_system.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final String iconPath;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.iconPath,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageAsset(
            iconPath,
            height: 16,
            color: isSelected ? Colors.white : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: isSelected ? Colors.white : null),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}
