import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/suggestion.dart';
import '../../providers/suggestions_provider.dart';
import '../widgets/suggestion_card_widget.dart';

class SuggestionsScreen extends ConsumerWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the suggestion data
    // In a real app, handle loading and error states here
    final asyncSuggestions = ref.watch(suggestionsProvider);
    final theme = Theme.of(context);

    // Group suggestions by time of day
    final morningSuggestions = asyncSuggestions
        .where((s) => s.timeOfDay == SuggestionTimeOfDay.morning)
        .toList();
    final afternoonSuggestions = asyncSuggestions
        .where((s) => s.timeOfDay == SuggestionTimeOfDay.afternoon)
        .toList();
    final eveningSuggestions = asyncSuggestions
        .where((s) => s.timeOfDay == SuggestionTimeOfDay.evening)
        .toList();

    return Scaffold(
      // Use a slightly darker background from the theme for immersion if desired
      // backgroundColor: theme.brightness == Brightness.dark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Your Kuriftu Day'),
        // Make AppBar slightly transparent or blend with background
        backgroundColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.85),
        elevation: 0, // Remove shadow for seamless look
        centerTitle: true,
      ),
      body: CustomScrollView(
        // Use CustomScrollView for more flexibility with slivers
        slivers: [
          // --- Morning Section ---
          _buildSectionHeader(context, "☀️ Morning Adventures"),
          _buildSuggestionList(morningSuggestions, 0), // Start delay index 0

          // --- Afternoon Section ---
          _buildSectionHeader(context, " M Afternoon Relaxation"),
          _buildSuggestionList(afternoonSuggestions,
              morningSuggestions.length), // Continue delay

          // --- Evening Section ---
          _buildSectionHeader(context, "🌙 Evening Experiences"),
          _buildSuggestionList(eveningSuggestions,
              morningSuggestions.length + afternoonSuggestions.length),

          // Add some padding at the bottom
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return SliverPadding(
      padding: const EdgeInsets.only(left: 20.0, top: 24.0, bottom: 8.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary, // Use primary color for headers
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1, curve: Curves.easeOut),
      ),
    );
  }

  // Helper widget to build the list of suggestion cards for a section
  Widget _buildSuggestionList(
      List<Suggestion> suggestions, int delayStartIndex) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final suggestion = suggestions[index];
          // Calculate staggered delay for each card
          final delay = Duration(milliseconds: 150 * (delayStartIndex + index));
          return SuggestionCard(
            suggestion: suggestion,
            animationDelay: delay,
          );
        },
        childCount: suggestions.length,
      ),
    );
  }
}
