import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6C63FF); // lavender
  static const Color secondary = Color(0xFF00AEEF); // soft blue
  static const Color bgGradientTop = Color(0xFFE9ECFF);
  static const Color bgGradientBottom = Color(0xFFD6E6FF);

  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    fontFamily: 'SF Pro',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.65),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
