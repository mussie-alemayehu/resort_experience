import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart'; // Use your theme

class SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final IconData? icon; // Optional icon

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    final selectedColor = isDark ? AppColors.secondary : colorScheme.primary;
    final selectedForegroundColor =
        isDark ? AppColors.backgroundDark : Colors.white;
    final unselectedColor = colorScheme.surfaceContainer.withValues(alpha: 0.5);
    final unselectedForegroundColor = colorScheme.onSurfaceVariant;

    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: AnimatedContainer(
        duration: 250.ms,
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : colorScheme.outline.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? selectedForegroundColor
                    : unselectedForegroundColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? selectedForegroundColor
                    : unselectedForegroundColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(target: isSelected ? 1 : 0) // Animate based on selection
        .scale(
            begin: const Offset(0.98, 0.98),
            end: const Offset(1, 1),
            duration: 200.ms,
            curve: Curves.easeOut)
        .shake(
            hz: 2,
            offset: isSelected ? const Offset(1, 0) : Offset.zero,
            duration: 300.ms); // Slight shake on select
  }
}
