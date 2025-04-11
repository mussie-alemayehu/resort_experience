import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StepTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const StepTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        )
            .animate()
            .fadeIn(delay: 100.ms)
            .slideX(begin: -0.1, curve: Curves.easeOut),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        )
            .animate()
            .fadeIn(delay: 200.ms)
            .slideX(begin: -0.1, curve: Curves.easeOut),
        const SizedBox(height: 25), // Spacing after title
      ],
    );
  }
}
