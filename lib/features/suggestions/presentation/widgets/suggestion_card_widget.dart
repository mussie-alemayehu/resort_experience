import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_experience/config/theme/app_colors.dart'; // Your colors
import 'package:resort_experience/core/icon_getter.dart';

import '../../models/suggestion.dart'; // Your Suggestion model
import '../../providers/activity_completion_provider.dart'; // Import the new provider

// Make it a ConsumerWidget to access providers
class SuggestionCard extends ConsumerWidget {
  final Suggestion suggestion;
  final Duration animationDelay;
  final String planId;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    this.animationDelay = Duration.zero,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Watch the completion status for this specific suggestion
    // Use suggestion.id as the key
    final isCompleted =
        ref.watch(activityCompletionProvider(planId))[suggestion.id] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        // Use Material for InkWell splash effect
        color: theme.cardColor, // Use cardColor from theme
        borderRadius: BorderRadius.circular(12.0),
        elevation: isCompleted ? 0.5 : 2.0, // Subtle elevation change
        shadowColor: Colors.black.withValues(alpha: 0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Icon ---
                Icon(
                  // Call the helper function instead of accessing suggestion.iconData
                  IconGetter.getIconForSuggestion(suggestion),
                  color: isCompleted
                      ? AppColors.success // Keep color logic
                      : theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 16),

                // --- Text Content ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion.title,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          // Dim title slightly if completed
                          color: isCompleted
                              ? textTheme.bodyMedium?.color?.withValues(
                                  alpha: 0.7) // Adjusted opacity application
                              : textTheme.bodyLarge
                                  ?.color, // Use bodyLarge or titleLarge color
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        suggestion.description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: isCompleted
                              ? theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5) // Adjusted opacity application
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // --- Duration & Completion Toggle ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Align items vertically
                  children: [
                    // --- Duration ---
                    // **IMPORTANT:** Use the correct field from your Suggestion model
                    // Renamed suggestion.timeLabel -> suggestion.durationLabel for clarity
                    Text(
                      suggestion
                          .timeLabel, // Use the appropriate field (e.g., durationLabel)
                      style: textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 25), // Space for the button

                    // --- Completion Toggle ---
                    InkWell(
                      onTap: () {
                        // Call the provider method to toggle the state
                        ref
                            .read(activityCompletionProvider(planId).notifier)
                            .toggleCompletion(suggestion.id);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 2.0), // Small padding for tap area
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle // Filled green check
                                  : Icons
                                      .radio_button_unchecked_outlined, // Outline grey/primary check
                              color: isCompleted
                                  ? AppColors.success
                                  : theme.colorScheme.primary
                                      .withValues(alpha: 0.7),
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isCompleted ? 'Completed' : 'Mark as done',
                              style: textTheme.labelLarge?.copyWith(
                                  color: isCompleted
                                      ? AppColors.success
                                      : theme.colorScheme.primary
                                          .withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    )
        // --- Card Entrance Animation ---
        .animate(delay: animationDelay)
        .fadeIn(duration: 500.ms)
        .moveY(begin: 20, curve: Curves.easeOut);
  }
}
