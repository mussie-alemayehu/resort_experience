import 'package:flutter/material.dart';

class SuggestionPlan {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final IconData icon; // An icon representing the plan type
  final Color highlightColor; // For visual accent

  SuggestionPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.highlightColor,
  });
}
