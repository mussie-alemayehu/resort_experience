import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resort_experience/features/dashboard/presentation/screens/dashboard.dart';
import 'package:resort_experience/features/services/presentation/screens/services_screen.dart';
import 'package:resort_experience/features/preferences/presentation/screens/add_preferences_screen.dart';
import 'package:resort_experience/features/preferences/presentation/screens/preferences_intro_screen.dart';
import 'package:resort_experience/features/suggestions/presentation/screens/suggestions_screen.dart';

import 'app_routes.dart'; // Import your routes

// Optional: Define a key for the root navigator
// Useful for showing dialogs/snackbars globally if needed
// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  // navigatorKey: _rootNavigatorKey, // Optional
  initialLocation: AppRoutes.dashboard, // Start at the dashboard
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      name: AppRoutes.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.services,
      name: AppRoutes.services,
      builder: (context, state) => const ServicesScreen(),
      // Optional: Add page transitions
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ServicesScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: AppRoutes.preferencesIntro,
      name: AppRoutes.preferencesIntro,
      builder: (context, state) => const PreferencesIntroScreen(),
    ),
    GoRoute(
      path: AppRoutes.addPreference,
      name: AppRoutes.addPreference,
      builder: (context, state) => const AddPreferenceScreen(),
    ),
    GoRoute(
      path: AppRoutes.suggestions,
      name: AppRoutes.suggestions,
      builder: (context, state) => const SuggestionsScreen(),
    ),
    // Example for nested routes or routes with parameters later
    // GoRoute(
    //   path: '/profile/:userId',
    //   builder: (context, state) {
    //     final userId = state.pathParameters['userId']!;
    //     return ProfileScreen(userId: userId);
    //   },
    // ),
  ],
  // Optional: Error handling for unknown routes
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page Not Found')),
    body: Center(
      child: Text('Error: ${state.error?.message ?? 'Route not found'}'),
    ),
  ),
);
