import 'package:flutter/material.dart';

enum SuggestionTimeOfDay { morning, afternoon, evening, any }

class Suggestion {
  final String id; // Unique ID for interactions later
  final String title;
  final String description;
  final String
      timeLabel; // e.g., "Starts 9:00 AM", "All Afternoon", "7:00 PM - 9:00 PM"
  final SuggestionTimeOfDay timeOfDay;
  final String imageUrl; // High-quality image URL
  final String location; // e.g., "Lakeside Deck", "Main Pool", "Spa Center"
  final Color highlightColor; // A specific color accent for the card

  Suggestion({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.timeOfDay,
    required this.imageUrl,
    required this.location,
    required this.highlightColor,
  });
}
