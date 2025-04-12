// lib/features/suggestions/domain/suggestion.dart (or your path)
import 'package:flutter/material.dart';

enum SuggestionTimeOfDay { morning, afternoon, evening, any }

class Suggestion {
  final String id;
  final String title;
  final String description;
  final String timeLabel; // e.g., "Starts 9:00 AM", "All Afternoon"
  final SuggestionTimeOfDay timeOfDay;
  final String
      imageUrl; // May not be used in the new card UI, but keep for data model
  final String location; // May not be used in the new card UI
  final Color highlightColor; // May not be used in the new card UI
  final String category; // <-- ADDED: e.g., "Food", "Spa", "Activity"
  final double? cost;
  // Consider adding a duration field if timeLabel isn't sufficient

  Suggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.timeOfDay,
    required this.imageUrl,
    required this.location,
    required this.highlightColor,
    required this.category, // <-- ADDED requirement in constructor
    this.cost,
  });

  // Optional: Add copyWith if needed later for state updates
  Suggestion copyWith({
    String? id,
    String? title,
    String? description,
    String? timeLabel,
    SuggestionTimeOfDay? timeOfDay,
    String? imageUrl,
    String? location,
    Color? highlightColor,
    String? category,
    double? cost,
  }) {
    return Suggestion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timeLabel: timeLabel ?? this.timeLabel,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      highlightColor: highlightColor ?? this.highlightColor,
      category: category ?? this.category, // <-- ADDED to copyWith logic
    );
  }
}
