import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
      ),

      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      canvasColor: AppColors.surfaceLight,
      dividerColor: AppColors.border,

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
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.textPrimaryLight,
        contentTextStyle: TextStyle(color: AppColors.textPrimaryDark),
        behavior: SnackBarBehavior.floating,
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(AppColors.textPrimaryDark),
        side: const BorderSide(color: AppColors.textSecondaryLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldBackground,
        hintStyle: TextStyle(color: AppColors.textSecondaryLight),
        labelStyle: TextStyle(color: AppColors.textSecondaryLight),
        floatingLabelStyle: TextStyle(color: AppColors.textSecondaryLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
      ),

      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgDark,
      canvasColor: AppColors.surfaceDark,
      dividerColor: Colors.white12,

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
        surfaceTintColor: Colors.transparent,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        contentTextStyle: TextStyle(color: AppColors.textPrimaryDark),
        behavior: SnackBarBehavior.floating,
      ),

      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(AppColors.textPrimaryLight),
        side: const BorderSide(color: AppColors.textSecondaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
        ),
      ),

      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldBackgroundDark,
        hintStyle: TextStyle(color: AppColors.textSecondaryDark),
        labelStyle: TextStyle(color: AppColors.textSecondaryDark),
        floatingLabelStyle: TextStyle(color: AppColors.textSecondaryDark),
      ),
    );
  }
}
