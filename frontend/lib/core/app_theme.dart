import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgLight,
      fontFamily: 'Gabarito', // Properti 1: Font Family

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight, // Warna background navbar
        selectedItemColor: AppColors.primary, // Warna ikon saat dipilih (Biru)
        unselectedItemColor: Color(0xFF727176), // Warna ikon saat tidak dipilih
        elevation: 2, // Ketebalan bayangan
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0.5,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight, // Properti 2: Background Color
        elevation: 1,
        surfaceTintColor:
            Colors.transparent, // Mencegah warna ungu default Material 3
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Alexandria',
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: AppColors.textPrimaryLight,
        ), // Properti 3: Color
        bodyMedium: TextStyle(
          color: AppColors.textSecondaryLight,
          fontSize: 16,
        ), // Properti 4: Size
        bodySmall: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14),
      ),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.bgDark,
      fontFamily: 'Gabarito',

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark, // Warna background navbar
        selectedItemColor: AppColors.primary, // Warna ikon saat dipilih (Biru)
        unselectedItemColor: Color(0xFF727176), // Warna ikon saat tidak dipilih
        elevation: 0, // Ketebalan bayangan
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight, // Properti 2: Background Color
        elevation: 1,
        surfaceTintColor:
            Colors.transparent, // Mencegah warna ungu default Material 3
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
      ),
    );
  }
}
