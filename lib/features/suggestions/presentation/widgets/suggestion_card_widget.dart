import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/suggestion.dart';

class SuggestionCard extends StatelessWidget {
  final Suggestion suggestion;
  final Duration animationDelay;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    this.animationDelay = Duration.zero, // Delay for staggering animations
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme; // Use defined text themes

    return Container(
      height: 320, // Increased height for better image display
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Use theme surface color
        borderRadius: BorderRadius.circular(24), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // --- Background Image ---
            Positioned.fill(
              child: Image.network(
                suggestion.imageUrl,
                fit: BoxFit.cover,
                // Loading Builder for smoother image loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: suggestion.highlightColor,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              ).animate(delay: animationDelay).fadeIn(duration: 700.ms),
            ),

            // --- Gradient Overlay ---
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black
                          .withValues(alpha: 0.0), // More transparency at top
                      Colors.black.withValues(alpha: 0.85), // Darker at bottom
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.4, 1.0], // Gradient starts lower
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Take minimum space needed
                  children: [
                    // Location Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            suggestion.highlightColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        suggestion.location.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    )
                        .animate(delay: animationDelay + 200.ms)
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -0.2, curve: Curves.easeOut),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      suggestion.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          // Subtle shadow for better contrast
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.black.withValues(alpha: 0.5),
                            offset: const Offset(1.0, 1.0),
                          ),
                        ],
                      ),
                    )
                        .animate(delay: animationDelay + 300.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.2, curve: Curves.easeOutCirc),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      suggestion.description,
                      maxLines: 3, // Limit description lines
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4, // Line height
                      ),
                    )
                        .animate(delay: animationDelay + 450.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.3, curve: Curves.easeOut),

                    const SizedBox(height: 16),

                    // Time Label
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: suggestion.highlightColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          suggestion.timeLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                        .animate(delay: animationDelay + 550.ms)
                        .fadeIn(duration: 400.ms),
                  ],
                ),
              ),
            ),

            // Optional: Add interaction (e.g., tap to view details)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    // TODO: Navigate to suggestion detail page or show modal
                    print("Tapped suggestion: ${suggestion.title}");
                  },
                  splashColor: suggestion.highlightColor.withValues(alpha: 0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        // --- Card Entrance Animation ---
        .animate(delay: animationDelay)
        .fadeIn(duration: 600.ms)
        .scaleXY(begin: 0.95, curve: Curves.easeOutBack)
        .moveY(begin: 30, curve: Curves.easeOut);
  }
}
