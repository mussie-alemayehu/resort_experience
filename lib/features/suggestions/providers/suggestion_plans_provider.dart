import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart';
import 'package:resort_experience/features/suggestions/models/suggestion_plan.dart';

// 1. Define the State Notifier
class SuggestionPlansNotifier extends StateNotifier<List<SuggestionPlan>> {
  // Initialize with placeholder data
  SuggestionPlansNotifier() : super(_initialPlans);

  // Static initial data (can be replaced by fetched data later)
  static final List<SuggestionPlan> _initialPlans = [
    SuggestionPlan(
      id: 'plan_relax',
      title: "Ultimate Relaxation",
      description:
          "Unwind and rejuvenate with spa treatments, poolside lounging, and serene moments.",
      imageUrl:
          "https://images.unsplash.com/photo-1571003123894-791c63128ab6?q=80&w=2070&auto=format&fit=crop",
      icon: Icons.spa_outlined,
      highlightColor: AppColors.primary.withValues(alpha: 0.8),
    ),
    SuggestionPlan(
      id: 'plan_adventure',
      title: "Adventure Seeker",
      description:
          "Explore nature trails, engage in water activities, and discover local culture.",
      imageUrl:
          "https://images.unsplash.com/photo-1473198024873-be5a17f6d739?q=80&w=2070&auto=format&fit=crop",
      icon: Icons.hiking_rounded,
      highlightColor: Colors.green.shade700.withValues(alpha: 0.8),
    ),
    SuggestionPlan(
      id: 'plan_culinary',
      title: "Gourmet Journey",
      description:
          "Indulge in exquisite dining experiences, from artisan breakfasts to starlit dinners.",
      imageUrl:
          "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop",
      icon: Icons.restaurant_menu,
      highlightColor: AppColors.secondary.withValues(alpha: 0.8),
    ),
    SuggestionPlan(
      id: 'plan_family',
      title: "Family Fun",
      description:
          "Activities designed for all ages, creating lasting memories together.",
      imageUrl:
          "https://plus.unsplash.com/premium_photo-1683288453196-ac46e8f915c6?q=80&w=2070&auto=format&fit=crop",
      icon: Icons.family_restroom_rounded,
      highlightColor: AppColors.accent.withValues(alpha: 0.7),
    ),
    // Add a placeholder for custom plans later?
    SuggestionPlan(
      id: 'plan_custom_placeholder', // Example
      title: "My Custom Kuriftu Plan",
      description: "A personalized experience based on your preferences.",
      imageUrl:
          "https://images.unsplash.com/photo-1517824806704-9040b037703b?q=80&w=2070&auto=format&fit=crop", // Generic travel image
      icon: Icons.edit_note_rounded,
      highlightColor: Colors.purple.shade400.withValues(alpha: 0.8),
    ),
  ];

  // --- Potential Future Methods ---

  // Method to fetch plans (replace initial data) - async example
  Future<void> fetchPlans() async {
    // state = []; // Show loading state?
    // try {
    //   final fetchedPlans = await _api.fetchSuggestionPlans(); // Replace with your API call
    //   state = fetchedPlans;
    // } catch (e) {
    //   // Handle error - maybe keep old state or set an error state
    //   print("Error fetching plans: $e");
    //   state = _initialPlans; // Fallback
    // }
  }

  // Method to add a plan (e.g., after it's created via API and returned)
  // Note: The 'Create Plan' screen likely triggers an API call to *generate*
  // a plan, not directly add one here. This method would be used if the
  // API returns the newly created plan details to be added to the list.
  void addPlan(SuggestionPlan newPlan) {
    // Prevent duplicates?
    if (!state.any((plan) => plan.id == newPlan.id)) {
      state = [...state, newPlan];
    }
  }

  // Method to remove a plan
  void removePlan(String planId) {
    state = state.where((plan) => plan.id != planId).toList();
  }

  // Method to update a plan (example)
  void updatePlan(SuggestionPlan updatedPlan) {
    state = [
      for (final plan in state)
        if (plan.id == updatedPlan.id) updatedPlan else plan,
    ];
  }
}

// 2. Define the StateNotifierProvider
final suggestionPlansProvider =
    StateNotifierProvider<SuggestionPlansNotifier, List<SuggestionPlan>>((ref) {
  return SuggestionPlansNotifier();
});
