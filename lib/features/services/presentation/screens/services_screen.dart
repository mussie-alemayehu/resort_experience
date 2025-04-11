import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resort Services & Activities')),
      body: Center(
        child:
            const Text('List/Grid of resort services (Spa, Dining, Pool, etc.)')
                .animate()
                .fadeIn()
                .slideY(), // Simple entrance animation
      ),
      // Example: Animated Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {/* Maybe filter services? */},
        child: const Icon(Icons.filter_list),
      ).animate().scale(delay: 800.ms),
    );
  }
}
