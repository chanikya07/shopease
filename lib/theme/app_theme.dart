import 'package:flutter/material.dart';

class AppTheme {
  static const Color navy = Color(0xFF0F172A);
  static const Color accent = Color(0xFFE65100); // high-contrast CTA colour
  static const Color bg = Color(0xFFF8F9FB);
  static const Color border = Color(0xFFE5E7EB);
  static const Color muted = Color(0xFF6B7280);
  static const Color success = Color(0xFF15803D);
  static const Color star = Color(0xFFF59E0B);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: navy,
          primary: navy,
          secondary: accent,
        ),
        scaffoldBackgroundColor: bg,
        dividerColor: border,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: navy, width: 1.6)),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: navy,
            side: const BorderSide(color: navy),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating, backgroundColor: navy),
      );
}
