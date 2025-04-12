import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_experience/core/config/theme/app_colors.dart'; // Your theme colors
import '../models/suggestion.dart'; // Import the updated Suggestion model

// Provider to supply the list of suggestions for a plan
// TODO: In a real app, change this to an AsyncNotifierProvider to fetch data dynamically
// based on user preferences, selected plan, date, etc.
final suggestionsProvider = Provider<List<Suggestion>>((ref) {
  // --- Placeholder Resort Activities ---
  // Replace with actual data fetching logic later.
  return [
    // Morning
    Suggestion(
      id: 'sug1',
      title: 'Sunrise Yoga & Meditation',
      description:
          'Greet the day with invigorating yoga poses and calming meditation by the serene lakeside.',
      timeLabel: '7:00 AM - 8:00 AM',
      timeOfDay: SuggestionTimeOfDay.morning,
      imageUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2120&auto=format&fit=crop',
      location: 'Lakeside Deck',
      highlightColor: AppColors.accent.withValues(
          alpha: 0.8), // Used withValues alpha: instead of withValues
      category: 'Wellness', // <-- ADDED
      cost: 15.00, // <-- ADDED (Example cost)
    ),
    Suggestion(
      id: 'sug2',
      title: 'Artisan Breakfast Experience',
      description:
          'Enjoy a curated breakfast featuring local ingredients and freshly brewed Ethiopian coffee.',
      timeLabel: '8:30 AM - 10:00 AM',
      timeOfDay: SuggestionTimeOfDay.morning,
      imageUrl:
          'https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=2070&auto=format&fit=crop',
      location: 'Main Restaurant Terrace',
      highlightColor: AppColors.secondary.withValues(alpha: 0.7),
      category: 'Food', // <-- ADDED
      cost: 25.00, // <-- ADDED (Example cost)
    ),

    // Afternoon
    Suggestion(
      id: 'sug3',
      title: 'Infinity Pool Relaxation',
      description:
          'Unwind by our stunning infinity pool with panoramic views and refreshing drinks.',
      timeLabel: 'All Afternoon',
      timeOfDay: SuggestionTimeOfDay.afternoon,
      imageUrl:
          'https://images.unsplash.com/photo-1571003123894-791c63128ab6?q=80&w=2070&auto=format&fit=crop',
      location: 'Main Pool Area',
      highlightColor: AppColors.primary.withValues(alpha: 0.7),
      category: 'Relaxation', // <-- ADDED
      cost: 0.00, // <-- ADDED (Example: Free access)
    ),
    Suggestion(
      id: 'sug4',
      title: 'Traditional Spa Ritual',
      description:
          'Indulge in a unique spa treatment inspired by ancient Ethiopian wellness practices.',
      timeLabel: 'Book Hourly: 1:00 PM - 5:00 PM',
      timeOfDay: SuggestionTimeOfDay.afternoon,
      imageUrl:
          'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?q=80&w=2070&auto=format&fit=crop',
      location: 'Kuriftu Spa Center',
      highlightColor: AppColors.accent.withValues(alpha: 0.9),
      category: 'Spa', // <-- ADDED
      cost: 95.00, // <-- ADDED (Example cost per treatment)
    ),
    Suggestion(
      id: 'sug5',
      title: 'Guided Nature Discovery',
      description:
          'Explore hidden trails and local flora/fauna with our knowledgeable nature guide.',
      timeLabel: '2:30 PM - 4:00 PM',
      timeOfDay: SuggestionTimeOfDay.afternoon,
      imageUrl:
          'https://images.unsplash.com/photo-1473198024873-be5a17f6d739?q=80&w=2070&auto=format&fit=crop',
      location: 'Resort Trails',
      highlightColor: Colors.green.shade700.withValues(alpha: 0.8),
      category: 'Activity', // <-- ADDED
      cost: 10.00, // <-- ADDED (Example cost)
    ),

    // Evening
    Suggestion(
      id: 'sug6',
      title: 'Sunset Cocktail Gathering',
      description:
          'Mingle and enjoy expertly crafted cocktails as the sun dips below the horizon.',
      timeLabel: '6:00 PM - 7:30 PM',
      timeOfDay: SuggestionTimeOfDay.evening,
      imageUrl:
          'https://images.unsplash.com/photo-1551024709-8f23befc6f87?q=80&w=2157&auto=format&fit=crop',
      location: 'Sunset View Bar',
      highlightColor: AppColors.secondary.withValues(alpha: 0.8),
      category: 'Event', // <-- ADDED
      cost: 0.00, // <-- ADDED (Assuming entry is free, pay per drink)
    ),
    Suggestion(
      id: 'sug7',
      title: 'Gourmet Dining Under the Stars',
      description:
          'Experience an unforgettable dinner featuring exquisite cuisine in a magical outdoor setting.',
      timeLabel: 'Starts 8:00 PM',
      timeOfDay: SuggestionTimeOfDay.evening,
      imageUrl:
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop',
      location: 'Garden Restaurant',
      highlightColor: AppColors.primary.withValues(alpha: 0.8),
      category: 'Dining', // <-- ADDED
      cost: 75.00, // <-- ADDED (Example cost for dinner set)
    ),
    Suggestion(
      id: 'sug8',
      title: 'Live Cultural Music Night',
      description:
          'Immerse yourself in the vibrant sounds of traditional Ethiopian music and dance.',
      timeLabel: '9:00 PM onwards',
      timeOfDay: SuggestionTimeOfDay.evening,
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1682310076134-3d86d70a2f64?q=80&w=2070&auto=format&fit=crop',
      location: 'Cultural Center Lounge',
      highlightColor: AppColors.accent.withValues(alpha: 0.7),
      category: 'Entertainment', // <-- ADDED
      cost: 5.00, // <-- ADDED (Example cover charge or free)
    ),
  ];
});

// --- Potential Future Enhancements ---

// If you need to fetch data asynchronously:
/*
final suggestionsRepositoryProvider = Provider((ref) => SuggestionsRepository()); // Your data fetching logic

final suggestionsNotifierProvider = AsyncNotifierProvider<SuggestionsNotifier, List<Suggestion>>(() {
  return SuggestionsNotifier();
});

class SuggestionsNotifier extends AsyncNotifier<List<Suggestion>> {
  @override
  Future<List<Suggestion>> build() async {
    // Initial fetch
    return _fetchSuggestions();
  }

  Future<List<Suggestion>> _fetchSuggestions({Map<String, dynamic>? filters}) async {
    final repository = ref.read(suggestionsRepositoryProvider);
    // Replace with your actual API call or data source access
    // Pass filters if implemented
    return await repository.fetchSuggestions(filters: filters);
  }

  Future<void> refreshSuggestions({Map<String, dynamic>? filters}) async {
    state = const AsyncValue.loading();
    try {
      final suggestions = await _fetchSuggestions(filters: filters);
      state = AsyncValue.data(suggestions);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  // You could add methods here to modify the list if necessary,
  // though often individual item state (like completion) is handled separately.
}
*/

// You might also want providers for specific filters or selected suggestions if needed.
