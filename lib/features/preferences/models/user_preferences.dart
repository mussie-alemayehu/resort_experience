// Enums for clarity (optional but recommended)
enum EnergyLevel { slow, balanced, high }

enum SocialPreference { introverted, fewNewFaces, meetEveryone }

enum TravelCompanion { justMe, partner, family, friends }

class UserPreferences {
  // Step 1
  Set<String> activityInterests = {};

  // Step 2
  bool? visitedTropicalResort;
  Set<String> travelGoals = {};

  // Step 3
  Set<String> idealDayActivities = {};
  EnergyLevel? energyLevel;

  // Step 4
  SocialPreference? socialPreference;
  TravelCompanion? travelCompanion;

  // Step 5
  String mustDoExperiences = '';
  String experiencesToAvoid = ''; // Optional

  // Helper to check if a step is complete (basic example)
  bool isStepComplete(int step) {
    switch (step) {
      case 0:
        return activityInterests.isNotEmpty;
      case 1:
        return visitedTropicalResort != null && travelGoals.isNotEmpty;
      case 2:
        return idealDayActivities.isNotEmpty && energyLevel != null;
      case 3:
        return socialPreference != null && travelCompanion != null;
      case 4:
        return true; // Step 5 is optional text, always "complete"
      case 5:
        return true; // Review step
      default:
        return false;
    }
  }

  // Convert data to JSON map for API
  Map<String, dynamic> toJson() {
    return {
      'activity_interests': activityInterests.toList(),
      'visited_tropical_resort': visitedTropicalResort,
      'travel_goals': travelGoals.toList(),
      'ideal_day_activities': idealDayActivities.toList(),
      // Convert enums back to strings or specific values for API
      'energy_level': energyLevel?.name, // Requires Dart 2.15+
      'social_preference': socialPreference?.name,
      'travel_companion': travelCompanion?.name,
      'must_do_experiences': mustDoExperiences.trim(),
      'experiences_to_avoid': experiencesToAvoid.trim(),
    };
  }

  // For debugging
  @override
  String toString() {
    return toJson().entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
}
