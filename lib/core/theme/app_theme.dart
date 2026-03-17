import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Dark Theme Palette – Premium Dark
  static const Color bgDeep = Color(0xFF060A10);
  static const Color bgSurface = Color(0xFF0D1117);
  static const Color bgCard = Color(0xFF161B22);
  static const Color bgGlass = Color(0xFF1C2333);

  // Accent / Brand
  static const Color accentBlue = Color(0xFF58A6FF);
  static const Color accentPurple = Color(0xFFBC8CFF);
  static const Color accentCyan = Color(0xFF39D0D8);
  static const Color accentGreen = Color(0xFF3FB950);

  // Gradients
  static const Color gradStart = Color(0xFF4F46E5); // Indigo
  static const Color gradMid = Color(0xFF7C3AED); // Violet
  static const Color gradEnd = Color(0xFF06B6D4); // Cyan

  // Text
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  // Border
  static const Color border = Color(0xFF21262D);
  static const Color borderHover = Color(0xFF30363D);

  // Light Theme
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
}

class AppTheme {
  static const Color primaryColor = Color(0xFF4F46E5);
  static const Color secondaryColor = Color(0xFF0F172A);
  static const Color accentColor = Color(0xFF06B6D4);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.accentBlue,
      scaffoldBackgroundColor: AppColors.bgDeep,
      cardColor: AppColors.bgCard,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentBlue,
        brightness: Brightness.dark,
        primary: AppColors.accentBlue,
        secondary: AppColors.accentPurple,
        tertiary: AppColors.accentCyan,
        surface: AppColors.bgCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDeep,
        elevation: 0,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: AppColors.lightBg,
      cardColor: AppColors.lightCard,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: AppColors.bgDeep,
        displayColor: AppColors.bgDeep,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: const Color(0xFF7C3AED),
        tertiary: accentColor,
        surface: AppColors.lightCard,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBg,
        elevation: 0,
      ),
    );
  }
}
