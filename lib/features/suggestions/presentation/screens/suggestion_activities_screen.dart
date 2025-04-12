import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart'; // Add this dependency
import 'package:resort_experience/core/config/router/app_routes.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart'; // Your colors

import '../../models/suggestion.dart';
import '../../providers/suggestions_provider.dart';
import '../../providers/activity_completion_provider.dart'; // Import completion provider
import '../widgets/suggestion_card_widget.dart'; // Import updated card

class SuggestionActivitiesScreen extends ConsumerWidget {
  final String planId;
  final String planTitle; // e.g., "Tropical Escape"

  const SuggestionActivitiesScreen({
    super.key,
    required this.planTitle,
    required this.planId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Assuming suggestionsProvider provides List<Suggestion> directly or handle async state
    final allSuggestions = ref.watch(suggestionsProvider);
    final completionPercentage =
        ref.watch(completionPercentageProvider(planId));
    // Watch completion percentage and count

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Group suggestions by time of day
    final morningSuggestions = allSuggestions
        .where((s) => s.timeOfDay == SuggestionTimeOfDay.morning)
        .toList();
    final afternoonSuggestions = allSuggestions
        .where((s) => s.timeOfDay == SuggestionTimeOfDay.afternoon)
        .toList();
    final eveningSuggestions = allSuggestions
        .where((s) => s.timeOfDay == SuggestionTimeOfDay.evening)
        .toList();

    final int totalSuggestions = allSuggestions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(planTitle),
        centerTitle: false, // Align title left as per screenshot
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 1, // Subtle shadow
        actions: [
          // --- Checkout Button ---
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart_checkout, size: 18),
              label: const Text('Checkout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary, // Use secondary color
                foregroundColor:
                    AppColors.textDark, // Adjust text color if needed
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ).copyWith(elevation: WidgetStateProperty.all(1.0)),
              onPressed: () {
                // Navigate to Checkout Screen
                context.push(
                  AppRoutes.checkout,
                  extra: {
                    'planTitle': planTitle,
                    'completedActivities': allSuggestions
                        .where((s) =>
                            ref.read(
                                activityCompletionProvider(planId))[s.id] ??
                            false)
                        .toList(),
                    'totalActivities': totalSuggestions,
                  },
                );
              },
            ),
          ),
          // --- Regenerate Button (Optional) ---
          // IconButton(
          //   icon: Icon(Icons.refresh, color: theme.colorScheme.secondary),
          //   onPressed: () { /* TODO: Implement Regenerate */ },
          // ),
        ],
        // --- Subtitle and Progress ---
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // Adjust height as needed
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Could be a subtitle or fixed text
                Text('Your Wellness Seek Itinerary',
                    style: textTheme.bodyMedium),
                Row(
                  children: [
                    SizedBox(
                      width: 80, // Adjust width
                      child: LinearPercentIndicator(
                        percent: completionPercentage,
                        lineHeight: 8.0,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        progressColor: AppColors.success,
                        barRadius: const Radius.circular(4),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(completionPercentage * 100).toStringAsFixed(0)}% completed',
                      style: textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // --- Itinerary Header ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 8.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Day Itinerary",
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 4),
                    Text(
                      "A perfect blend of relaxation and adventure tailored just for you.",
                      style: textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7)),
                    ).animate().fadeIn(delay: 200.ms),
                  ]),
            ),
          ),

          // --- Morning Section ---
          if (morningSuggestions.isNotEmpty) ...[
            _buildSectionHeader(context, Icons.wb_sunny_outlined, "Morning"),
            _buildSuggestionList(morningSuggestions, 0),
          ],

          // --- Afternoon Section ---
          if (afternoonSuggestions.isNotEmpty) ...[
            _buildSectionHeader(
                context, Icons.brightness_5_outlined, "Afternoon"),
            _buildSuggestionList(
                afternoonSuggestions, morningSuggestions.length),
          ],

          // --- Evening Section ---
          if (eveningSuggestions.isNotEmpty) ...[
            _buildSectionHeader(context, Icons.nightlight_outlined, "Evening"),
            _buildSuggestionList(eveningSuggestions,
                morningSuggestions.length + afternoonSuggestions.length),
          ],

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // Updated section header to include icon
  Widget _buildSectionHeader(
      BuildContext context, IconData icon, String title) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.only(
          left: 20.0, top: 28.0, bottom: 12.0, right: 20.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 10),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const Spacer(),
            Text(
              "Check activities to earn XP!", // Example text from screenshot
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.secondary),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1, curve: Curves.easeOut),
      ),
    );
  }

  // Helper to build suggestion list (mostly unchanged, ensures SuggestionCard is used)
  Widget _buildSuggestionList(
      List<Suggestion> suggestions, int delayStartIndex) {
    // Use SliverPadding for consistent horizontal padding for the list items
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: 0), // Card handles its own padding
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final suggestion = suggestions[index];
            final delay = Duration(
                milliseconds:
                    100 * (delayStartIndex + index) + 300); // Adjust timing
            return SuggestionCard(
              suggestion: suggestion,
              animationDelay: delay,
              planId: planId,
            );
          },
          childCount: suggestions.length,
        ),
      ),
    );
  }
}
