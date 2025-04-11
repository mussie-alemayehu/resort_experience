import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resort_experience/config/router/app_routes.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PreferencesIntroScreen extends StatelessWidget {
  const PreferencesIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Preferences')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tell us what you like!').animate().fadeIn(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.addPreference),
              child: const Text('Start Adding Preferences'),
            ).animate(delay: 300.ms).slideY(),
          ],
        ),
      ),
    );
  }
}
