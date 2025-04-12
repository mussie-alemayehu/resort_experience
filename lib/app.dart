import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

class KuriftuApp extends ConsumerWidget {
  const KuriftuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can watch providers here if needed for global settings,
    // e.g., theme mode provider
    // final themeMode = ref.watch(themeModeProvider);

    final appRouter = ref.read(goRouterProvider);

    return MaterialApp.router(
      title: 'Kuriftu Experience',
      debugShowCheckedModeBanner: false, // Disable debug banner

      // Routing Configuration
      routerConfig: appRouter,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode
          .system, // Or ThemeMode.light, ThemeMode.dark, or watch a provider

      // Other MaterialApp properties (localization, builders) can be added here later
    );
  }
}
