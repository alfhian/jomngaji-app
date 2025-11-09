import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData buildTheme() {
    const Color seedColor = Color(0xFF2EC5CE);
    const Color playfulSurface = Color(0xFFFFFAF1);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: seedColor,
        secondary: const Color(0xFFFF9B9B),
        tertiary: const Color(0xFF7C5CFF),
        surface: playfulSurface,
      ),
      scaffoldBackgroundColor: playfulSurface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C3C5D),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1C3C5D),
          letterSpacing: -0.5,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C3C5D),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF26435D),
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Color(0xFF4C5D70),
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: seedColor,
          side: const BorderSide(color: seedColor, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: Color(0xFFE3F8FF),
        labelStyle: TextStyle(
          color: Color(0xFF0F7690),
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        secondarySelectedColor: Color(0xFFFFE2E2),
        brightness: Brightness.light,
      ),
      cardTheme: const CardTheme(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF9B9B),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
