import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_experience/config/theme/app_colors.dart'; // Use your theme colors
import '../models/suggestion_plan.dart';

final suggestionPlansProvider = Provider<List<SuggestionPlan>>((ref) {
  // Placeholder plans - fetch these from a backend in a real app
  return [
    SuggestionPlan(
      id: 'plan_relax',
      title: "Ultimate Relaxation",
      description:
          "Unwind and rejuvenate with spa treatments, poolside lounging, and serene moments.",
      imageUrl:
          "https://images.unsplash.com/photo-1571003123894-791c63128ab6?q=80&w=2070&auto=format&fit=crop", // Pool Image
      icon: Icons.spa_outlined,
      highlightColor: AppColors.primary.withValues(alpha: 0.8),
    ),
    SuggestionPlan(
      id: 'plan_adventure',
      title: "Adventure Seeker",
      description:
          "Explore nature trails, engage in water activities, and discover local culture.",
      imageUrl:
          "https://images.unsplash.com/photo-1473198024873-be5a17f6d739?q=80&w=2070&auto=format&fit=crop", // Nature Walk Image
      icon: Icons.hiking_rounded,
      highlightColor: Colors.green.shade700.withValues(alpha: 0.8),
    ),
    SuggestionPlan(
      id: 'plan_culinary',
      title: "Gourmet Journey",
      description:
          "Indulge in exquisite dining experiences, from artisan breakfasts to starlit dinners.",
      imageUrl:
          "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop", // Dining Image
      icon: Icons.restaurant_menu,
      highlightColor: AppColors.secondary.withValues(alpha: 0.8),
    ),
    SuggestionPlan(
      id: 'plan_family',
      title: "Family Fun",
      description:
          "Activities designed for all ages, creating lasting memories together.",
      imageUrl:
          "https://plus.unsplash.com/premium_photo-1683288453196-ac46e8f915c6?q=80&w=2070&auto=format&fit=crop", // Family friendly image
      icon: Icons.family_restroom_rounded,
      highlightColor: AppColors.accent.withValues(alpha: 0.7),
    ),
  ];
});
