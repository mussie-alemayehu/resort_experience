import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  // Using Lato - clean and readable
  static TextTheme get lightTextTheme => GoogleFonts.latoTextTheme(
        TextTheme(
          displayLarge: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textLight),
          displayMedium: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textLight),
          displaySmall: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textLight),
          headlineMedium: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textLight),
          headlineSmall: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textLight),
          titleLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
          titleMedium: const TextStyle(color: AppColors.textLight),
          titleSmall: const TextStyle(color: AppColors.textLight),
          bodyLarge: const TextStyle(color: AppColors.textLight),
          bodyMedium: const TextStyle(
            color: AppColors.textLight,
          ), // Default text style
          bodySmall:
              TextStyle(color: AppColors.textLight.withValues(alpha: 0.8)),
          labelLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ), // For buttons
          labelMedium: TextStyle(
            color: AppColors.textLight.withValues(alpha: 0.9),
          ),
          labelSmall: TextStyle(
            color: AppColors.textLight.withValues(alpha: 0.7),
          ),
        ),
      );

  static TextTheme get darkTextTheme => GoogleFonts.latoTextTheme(
        TextTheme(
          displayLarge: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textDark),
          displayMedium: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textDark),
          displaySmall: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textDark),
          headlineMedium: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textDark),
          headlineSmall: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textDark),
          titleLarge: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textDark),
          titleMedium: const TextStyle(color: AppColors.textDark),
          titleSmall: const TextStyle(color: AppColors.textDark),
          bodyLarge: const TextStyle(color: AppColors.textDark),
          bodyMedium:
              const TextStyle(color: AppColors.textDark), // Default text style
          bodySmall:
              TextStyle(color: AppColors.textDark.withValues(alpha: 0.8)),
          labelLarge: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary), // Buttons in dark
          labelMedium:
              TextStyle(color: AppColors.textDark.withValues(alpha: 0.9)),
          labelSmall:
              TextStyle(color: AppColors.textDark.withValues(alpha: 0.7)),
        ),
      );
}
