import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import animate
import 'package:go_router/go_router.dart';
import 'package:resort_experience/core/config/router/app_routes.dart'; // Routes

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Kuriftu Resort'),
        // Example: Add slight animation to title
        title: const Text('Kuriftu Resort')
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Kuriftu!',
              style: theme.textTheme.headlineMedium,
            )
                .animate()
                .fade(delay: 300.ms)
                .slideY(begin: 0.5), // Example animation
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.preferencesIntro),
              child: const Text('Set Preferences'),
            ).animate().fade(delay: 500.ms).slideX(),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.suggestionPlans),
              child: const Text('View Suggestions'),
            ).animate().fade(delay: 600.ms).slideX(begin: 0.5),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.services),
              child: const Text('Explore Services'),
            ).animate().fade(delay: 700.ms).slideX(begin: -0.5),
          ],
        ),
      ),
    );
  }
}
