import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFc89849);
  static const Color backgroundColor = Color(0xFF323b40);
  static const Color white = Colors.white;
  static const Color errorRed = Color(0xFFFF3B30);

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        background: backgroundColor,
        primary: primaryColor,
        error: errorRed,
      ),
      scaffoldBackgroundColor: backgroundColor,
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Colors.black,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.7),
        ),
        prefixIconColor: Colors.black.withOpacity(0.7),
      ),
    );
  }
} 