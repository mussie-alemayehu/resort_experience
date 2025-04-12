import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart';
import 'package:resort_experience/core/icon_getter.dart';

import '../../models/suggestion.dart';

class CheckoutScreen extends ConsumerWidget {
  final String planTitle;
  final List<Suggestion> completedActivities;
  final int totalActivities;

  const CheckoutScreen({
    super.key,
    required this.planTitle,
    required this.completedActivities,
    required this.totalActivities,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Calculate totals (handle null costs)
    double subtotal = 0.0;
    for (final activity in completedActivities) {
      subtotal += activity.cost ?? 0.0;
    }
    // Placeholder for discount logic
    double discountAmount = 0.0;
    double total = subtotal - discountAmount;

    // Get completion percentage (can re-use the provider)
    final completionPercentage = (totalActivities > 0)
        ? completedActivities.length / totalActivities
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: false,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Your completed activities from ',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  TextSpan(
                    text: planTitle,
                    style: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: ' (${completedActivities.length} completed)',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Completed Activities List ---
            _buildSectionCard(
              context,
              title: 'Completed Activities',
              child: ListView.separated(
                shrinkWrap: true, // Important inside SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Disable nested scrolling
                itemCount: completedActivities.length,
                itemBuilder: (context, index) {
                  final activity = completedActivities[index];
                  return ListTile(
                    leading: Icon(
                      // Call the helper function instead of accessing activity.iconData
                      IconGetter.getIconForSuggestion(activity),
                      color: theme
                          .colorScheme.primary, // Icon color in checkout list
                    ),
                    title: Text(activity.title, style: textTheme.bodyLarge),
                    // Display time/duration on left, cost on right
                    trailing: Text(
                      // Assume activity.cost exists and is double?
                      '\$${(activity.cost ?? 0.0).toStringAsFixed(2)}', // Format cost
                      style: textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    // **IMPORTANT:** Use the correct field from your Suggestion model for subtitle
                    // Renamed activity.timeLabel -> activity.durationLabel for clarity
                    subtitle: Text(
                      activity
                          .timeLabel, // Use the appropriate field (e.g., durationLabel)
                      style: textTheme.bodySmall,
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                },
                separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.dividerColor.withValues(alpha: 0.5)),
              ),
            ),
            const SizedBox(height: 20),

            // --- Summary Section ---
            _buildSectionCard(
              context,
              title: 'Summary',
              child: Column(
                children: [
                  _buildSummaryRow(context, 'Total Activities',
                      '${completedActivities.length}'),
                  _buildSummaryRow(
                      context, 'Add Costs', '\$0.00'), // Placeholder
                  const Divider(height: 15),
                  _buildSummaryRow(
                      context, 'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                  _buildSummaryRow(context, 'Discount Amount',
                      '- \$${discountAmount.toStringAsFixed(2)}',
                      isDiscount: true),
                  const Divider(height: 15, thickness: 1.5),
                  _buildSummaryRow(
                      context, 'Total', '\$${total.toStringAsFixed(2)}',
                      isTotal: true),
                  const SizedBox(height: 10),
                  // --- Discount Code ---
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Enter Discount Code',
                              isDense: true,
                              filled: true,
                              fillColor: theme
                                  .colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10)),
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {/* TODO: Apply Discount */},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Apply'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- Completion Status ---
            _buildSectionCard(context,
                title: 'Completion Status',
                child: Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        percent: completionPercentage,
                        lineHeight: 12.0,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        progressColor: AppColors.success,
                        barRadius: const Radius.circular(6),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(completionPercentage * 100).toStringAsFixed(0)}%',
                      style: textTheme.titleMedium?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            const SizedBox(height: 30), // Bottom padding
          ],
        ),
      ),
    );
  }

  // Helper for consistent card styling
  Widget _buildSectionCard(BuildContext context,
      {required String title, required Widget child}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      elevation: 1.5,
      margin: EdgeInsets.zero, // Use padding outside if needed
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  // Helper for summary rows
  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                : textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                : textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDiscount ? AppColors.error : null),
          ),
        ],
      ),
    );
  }
}
