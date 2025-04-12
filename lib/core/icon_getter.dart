import 'package:flutter/material.dart';
import 'package:resort_experience/features/suggestions/models/suggestion.dart';

class IconGetter {
  static IconData getIconForSuggestion(Suggestion suggestion) {
    // Use category first if available
    final category =
        suggestion.category.toLowerCase(); // Make it case-insensitive
    switch (category) {
      case 'food':
      case 'breakfast':
      case 'lunch':
      case 'dinner':
      case 'bbq':
      case 'restaurant':
        return Icons.restaurant_rounded; // Changed to rounded
      case 'spa':
      case 'treatment':
      case 'wellness':
        return Icons.spa_rounded; // Changed to rounded
      case 'excursion':
      case 'tour':
      case 'activity':
      case 'explore':
        return Icons.explore_rounded; // Changed to rounded
      case 'relaxation':
      case 'beach':
      case 'pool':
        return Icons.beach_access_rounded; // Changed to rounded
      case 'event':
      case 'class':
      case 'cooking class':
        return Icons.event_note_rounded; // Changed to rounded
      // Add more specific categories relevant to your resort
      default:
        // Fallback if category doesn't match known types
        break; // Continue to keyword check
    }

    // --- Fallback: Check keywords in title (less reliable) ---
    final titleLower = suggestion.title.toLowerCase();
    if (titleLower.contains('breakfast') ||
        titleLower.contains('lunch') ||
        titleLower.contains('dinner') ||
        titleLower.contains('food') ||
        titleLower.contains('bbq') ||
        titleLower.contains('restaurant')) {
      return Icons.restaurant_rounded;
    }
    if (titleLower.contains('spa') || titleLower.contains('treatment')) {
      return Icons.spa_rounded;
    }
    if (titleLower.contains('tour') ||
        titleLower.contains('excursion') ||
        titleLower.contains('explore')) {
      return Icons.explore_rounded;
    }
    if (titleLower.contains('beach') ||
        titleLower.contains('pool') ||
        titleLower.contains('relax')) {
      return Icons.beach_access_rounded;
    }
    if (titleLower.contains('class') || titleLower.contains('event')) {
      return Icons.event_note_rounded;
    }

    // --- Absolute Default ---
    return Icons.local_activity_rounded; // Generic default icon
  }
}
