import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_experience/config/theme/app_colors.dart'; // Use your theme colors
import '../models/suggestion.dart';

final suggestionsProvider = Provider<List<Suggestion>>((ref) {
  // --- Placeholder Resort Activities ---
  // In a real app, this would fetch data based on user preferences, date, etc.
  return [
    // Morning
    Suggestion(
      id: 'sug1',
      title: "Sunrise Yoga & Meditation",
      description:
          "Greet the day with invigorating yoga poses and calming meditation by the serene lakeside.",
      timeLabel: "7:00 AM - 8:00 AM",
      timeOfDay: SuggestionTimeOfDay.morning,
      imageUrl:
          "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2120&auto=format&fit=crop", // Yoga Image
      location: "Lakeside Deck",
      highlightColor: AppColors.accent.withOpacity(0.8),
    ),
    Suggestion(
      id: 'sug2',
      title: "Artisan Breakfast Experience",
      description:
          "Enjoy a curated breakfast featuring local ingredients and freshly brewed Ethiopian coffee.",
      timeLabel: "8:30 AM - 10:00 AM",
      timeOfDay: SuggestionTimeOfDay.morning,
      imageUrl:
          "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?q=80&w=2070&auto=format&fit=crop", // Breakfast Image
      location: "Main Restaurant Terrace",
      highlightColor: AppColors.secondary.withOpacity(0.7),
    ),

    // Afternoon
    Suggestion(
      id: 'sug3',
      title: "Infinity Pool Relaxation",
      description:
          "Unwind by our stunning infinity pool with panoramic views and refreshing drinks.",
      timeLabel: "All Afternoon",
      timeOfDay: SuggestionTimeOfDay.afternoon,
      imageUrl:
          "https://images.unsplash.com/photo-1571003123894-791c63128ab6?q=80&w=2070&auto=format&fit=crop", // Pool Image
      location: "Main Pool Area",
      highlightColor: AppColors.primary.withOpacity(0.7),
    ),
    Suggestion(
      id: 'sug4',
      title: "Traditional Spa Ritual",
      description:
          "Indulge in a unique spa treatment inspired by ancient Ethiopian wellness practices.",
      timeLabel: "Book Hourly: 1:00 PM - 5:00 PM",
      timeOfDay: SuggestionTimeOfDay.afternoon,
      imageUrl:
          "https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2?q=80&w=2070&auto=format&fit=crop", // Spa Image
      location: "Kuriftu Spa Center",
      highlightColor: AppColors.accent.withOpacity(0.9),
    ),
    Suggestion(
      id: 'sug5',
      title: "Guided Nature Discovery",
      description:
          "Explore hidden trails and local flora/fauna with our knowledgeable nature guide.",
      timeLabel: "2:30 PM - 4:00 PM",
      timeOfDay: SuggestionTimeOfDay.afternoon,
      imageUrl:
          "https://images.unsplash.com/photo-1473198024873-be5a17f6d739?q=80&w=2070&auto=format&fit=crop", // Nature Walk Image
      location: "Resort Trails",
      highlightColor: Colors.green.shade700.withOpacity(0.8), // Custom color
    ),

    // Evening
    Suggestion(
      id: 'sug6',
      title: "Sunset Cocktail Gathering",
      description:
          "Mingle and enjoy expertly crafted cocktails as the sun dips below the horizon.",
      timeLabel: "6:00 PM - 7:30 PM",
      timeOfDay: SuggestionTimeOfDay.evening,
      imageUrl:
          "https://images.unsplash.com/photo-1551024709-8f23befc6f87?q=80&w=2157&auto=format&fit=crop", // Cocktail Image
      location: "Sunset View Bar",
      highlightColor: AppColors.secondary.withOpacity(0.8),
    ),
    Suggestion(
      id: 'sug7',
      title: "Gourmet Dining Under the Stars",
      description:
          "Experience an unforgettable dinner featuring exquisite cuisine in a magical outdoor setting.",
      timeLabel: "Starts 8:00 PM",
      timeOfDay: SuggestionTimeOfDay.evening,
      imageUrl:
          "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=1974&auto=format&fit=crop", // Dining Image
      location: "Garden Restaurant",
      highlightColor: AppColors.primary.withOpacity(0.8),
    ),
    Suggestion(
      id: 'sug8',
      title: "Live Cultural Music Night",
      description:
          "Immerse yourself in the vibrant sounds of traditional Ethiopian music and dance.",
      timeLabel: "9:00 PM onwards",
      timeOfDay: SuggestionTimeOfDay.evening,
      imageUrl:
          "https://plus.unsplash.com/premium_photo-1682310076134-3d86d70a2f64?q=80&w=2070&auto=format&fit=crop", // Music Image
      location: "Cultural Center Lounge",
      highlightColor: AppColors.accent.withOpacity(0.7),
    ),
  ];
});
