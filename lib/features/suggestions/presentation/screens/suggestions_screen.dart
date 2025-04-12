import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:resort_experience/config/router/app_routes.dart';
import 'package:resort_experience/config/theme/app_colors.dart'; // Use your theme colors
import '../../providers/suggestion_plans_provider.dart';
import '../widgets/suggestion_plan_card_widget.dart'; // Import the new card

class SuggestionsScreen extends ConsumerWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionPlans = ref.watch(suggestionPlansProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Experience')
            .animate()
            .fadeIn(delay: 300.ms, duration: 500.ms),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Blend with background
        elevation: 0,
      ),
      // Extend body behind AppBar for seamless background
      // extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          // --- Header/Intro Text ---
          SliverPadding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Select a curated plan or customize your perfect day at Kuriftu.',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms)
                  .moveY(begin: 10, curve: Curves.easeOut),
            ),
          ),

          // --- List of Suggestion Plans ---
          SliverPadding(
            padding: const EdgeInsets.only(
                top: 10.0, bottom: 5.0), // Add padding around the list
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final plan = suggestionPlans[index];
                  final delay = Duration(
                      milliseconds:
                          150 * index + 600); // Stagger animation after header
                  return SuggestionPlanCard(
                    plan: plan,
                    animationDelay: delay,
                  );
                },
                childCount: suggestionPlans.length,
              ),
            ),
          ),

          // --- Action Buttons ---
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Icons.add_circle_outline_rounded,
                    label: 'Create New Suggestion',
                    color: AppColors.accent, // Or your theme's accent
                    onTap: () {
                      context.push(AppRoutes.createPlan);
                    },
                    delay: Duration(
                      milliseconds: 150 * suggestionPlans.length + 700,
                    ), // Animate after list
                  ),
                  const SizedBox(height: 15),
                  _buildActionButton(
                    context: context,
                    icon: Icons.tune_rounded,
                    label: 'Update Your Preferences',
                    color: AppColors.secondary, // Or your theme's secondary
                    onTap: () {
                      context.push(AppRoutes.preferencesIntro);
                    },
                    delay: Duration(
                      milliseconds: 150 * suggestionPlans.length + 800,
                    ), // Animate after first button
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  // Helper for Action Buttons
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required Duration delay,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text/Icon color
        backgroundColor: color.withValues(alpha: 0.9),
        minimumSize:
            const Size(double.infinity, 50), // Full width, fixed height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle:
            theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        elevation: 3,
        shadowColor: color.withValues(alpha: 0.3),
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 500.ms)
        .moveY(begin: 20, curve: Curves.easeOut);
  }
}
