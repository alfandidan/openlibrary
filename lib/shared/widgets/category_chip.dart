import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;

  const CategoryChip({
    super.key,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surface,
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.white
              : Theme.of(context).textTheme.bodyMedium?.color,
        ),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}
