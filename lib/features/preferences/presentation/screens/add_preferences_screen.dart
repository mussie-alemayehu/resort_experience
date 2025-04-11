import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AddPreferenceScreen extends StatelessWidget {
  const AddPreferenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Preference')),
      body: Center(
        child:
            const Text('Preference selection UI goes here (e.g., list, chips)')
                .animate()
                .fadeIn(delay: 200.ms)
                .scaleXY(begin: 0.8),
      ),
    );
  }
}
