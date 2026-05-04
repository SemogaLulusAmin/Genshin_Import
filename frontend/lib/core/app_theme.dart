import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Core colors
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,

      // Typography
      fontFamily: 'Rubik',
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'HyWenhei',
          fontSize: 22,
          color: AppColors.textPrimaryLight,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimaryLight),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Core colors
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgDark,

      // Typography
      fontFamily: 'Rubik',
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'HyWenhei',
          fontSize: 22,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.textPrimaryDark),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
