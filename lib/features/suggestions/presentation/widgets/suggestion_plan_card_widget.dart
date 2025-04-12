import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:resort_experience/core/config/router/app_routes.dart';
import '../../models/suggestion_plan.dart';

class SuggestionPlanCard extends StatelessWidget {
  final SuggestionPlan plan;
  final Duration animationDelay;

  const SuggestionPlanCard({
    super.key,
    required this.plan,
    this.animationDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      height: 180, // Adjust height as needed
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // --- Background Image ---
            Positioned.fill(
              child: Image.network(
                plan.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: plan.highlightColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ).animate(delay: animationDelay).fadeIn(duration: 600.ms),
            ),

            // --- Gradient Overlay ---
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      plan.highlightColor
                          .withValues(alpha: 0.3), // Top color tint
                      Colors.black.withValues(alpha: 0.7), // Darker at bottom
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.8],
                  ),
                ),
              ),
            ),

            // --- Content ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  // Use Row for Icon and Text
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(plan.icon,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 36)
                        .animate(delay: animationDelay + 300.ms)
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.3, curve: Curves.easeOut),
                    const SizedBox(width: 12),
                    Expanded(
                      // Allow text column to take remaining space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            plan.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.black.withValues(alpha: 0.5)),
                              ],
                            ),
                          )
                              .animate(delay: animationDelay + 400.ms)
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.2, curve: Curves.easeOut),
                          const SizedBox(height: 4),
                          Text(
                            plan.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.3,
                            ),
                          )
                              .animate(delay: animationDelay + 500.ms)
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.3, curve: Curves.easeOut),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Interaction ---
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    // Navigate to the detailed activities screen
                    context.push(
                      AppRoutes.suggestionActivities,
                      extra: {'planTitle': plan.title, 'planId': plan.id},
                    );
                  },
                  splashColor: plan.highlightColor.withValues(alpha: 0.3),
                  highlightColor: plan.highlightColor.withValues(alpha: 0.15),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        // --- Card Entrance Animation ---
        .animate(delay: animationDelay)
        .fadeIn(duration: 500.ms)
        .moveY(begin: 40, end: 0, duration: 400.ms, curve: Curves.easeOut)
        .slideX(begin: -0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
