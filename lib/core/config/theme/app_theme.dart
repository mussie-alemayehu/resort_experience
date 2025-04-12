import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppColors.textLight,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      textTheme: AppTypography.lightTextTheme,
      appBarTheme: AppBarTheme(
        elevation: 0, // Flat design
        backgroundColor: AppColors.backgroundLight, // Or AppColors.primary
        foregroundColor: AppColors.textLight, // Title/Icon color
        centerTitle: true,
        titleTextStyle: AppTypography.lightTextTheme.headlineSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.lightTextTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surfaceLight,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      // Define other theme properties like input decoration, etc.
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor:
          AppColors.primary, // Or maybe secondary works better in dark?
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary, // Keep primary consistent?
        secondary: AppColors.secondary, // Accent color
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.textDark,
        onSurface: AppColors.textDark,
        onError: Colors.black,
        brightness: Brightness.dark,
      ),
      textTheme: AppTypography.darkTextTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.backgroundDark, // Or surfaceDark
        foregroundColor: AppColors.textDark,
        centerTitle: true,
        titleTextStyle: AppTypography.darkTextTheme.headlineSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary, // Use accent in dark?
          foregroundColor: AppColors.backgroundDark, // Text on accent button
          textStyle: AppTypography.darkTextTheme.labelLarge
              ?.copyWith(color: AppColors.backgroundDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 4, // Maybe slightly more elevation in dark mode
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surfaceDark,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      // Define other theme properties
    );
  }
}
