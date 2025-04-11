import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart'; // Import the App widget

void main() {
  // Ensure Flutter bindings are initialized (important for async setup)
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app within a ProviderScope for Riverpod state management
  runApp(
    const ProviderScope(
      child: KuriftuApp(),
    ),
  );
}
