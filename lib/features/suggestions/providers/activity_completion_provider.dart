import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_experience/features/suggestions/models/suggestion.dart';
import 'package:resort_experience/features/suggestions/providers/suggestions_provider.dart';

// Notifier holds the state (Map of suggestion ID -> completion status)
class ActivityCompletionNotifier extends StateNotifier<Map<String, bool>> {
  // Initialize with an empty map
  ActivityCompletionNotifier() : super({});

  // Method to toggle the completion status for a given suggestion ID
  void toggleCompletion(String suggestionId) {
    state = {
      ...state, // Copy existing state
      suggestionId: !(state[suggestionId] ?? false), // Toggle the value
    };
  }

  // Optional: Method to reset state if needed
  void reset() {
    state = {};
  }
}

// --- Main Provider using .family ---
// Now creates a separate ActivityCompletionNotifier for each planId
final activityCompletionProvider = StateNotifierProvider.family<
    ActivityCompletionNotifier, Map<String, bool>, String>((ref, planId) {
  // Each family instance gets its own notifier
  return ActivityCompletionNotifier();
  // Note: Riverpod handles disposal of these notifiers when they are no longer used.
});

// --- Helper Providers using .family ---

// Gets the count of completed activities for a specific planId
final completedActivitiesCountProvider =
    Provider.family<int, String>((ref, planId) {
  // Watch the specific instance of the state for the given planId
  final completionState = ref.watch(activityCompletionProvider(planId));
  return completionState.values.where((isCompleted) => isCompleted).length;
});

// Calculates completion percentage for a specific planId
final completionPercentageProvider =
    Provider.family<double, String>((ref, planId) {
  // Assumption: suggestionsProvider currently holds the list for the *active* plan.
  // TODO: For better accuracy with multiple plans potentially loaded,
  // make suggestionsProvider also a family: Provider.family<List<Suggestion>, String>
  // Or pass the specific suggestion list for this planId if available.
  final allSuggestionsForPlan =
      ref.watch(suggestionsProvider); // Using global for now

  if (allSuggestionsForPlan.isEmpty) return 0.0;

  // Watch the completed count for the specific planId
  final completedCount = ref.watch(completedActivitiesCountProvider(planId));

  return completedCount / allSuggestionsForPlan.length;
});

// Provider to get the list of completed suggestion *objects* for a specific plan
final completedSuggestionsProvider =
    Provider.family<List<Suggestion>, String>((ref, planId) {
  final allSuggestionsForPlan =
      ref.watch(suggestionsProvider); // Same assumption as above
  final completionState = ref.watch(activityCompletionProvider(planId));

  return allSuggestionsForPlan.where((suggestion) {
    return completionState[suggestion.id] ?? false;
  }).toList();
});
