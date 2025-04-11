import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SuggestionsScreen extends StatelessWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personalized Suggestions')),
      body: Center(
        child: const Text('AI-generated activity suggestions will appear here.')
            .animate()
            .shimmer(duration: 1200.ms), // Example loading shimmer
      ),
    );
  }
}
