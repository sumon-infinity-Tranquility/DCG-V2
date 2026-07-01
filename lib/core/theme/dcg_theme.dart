import 'package:flutter/material.dart';

class DcgTheme {
  static const bg = Color(0xFFF5F5FA);
  static const surface = Color(0xFFFFFFFF);
  static const slate = Color(0xFF313A51);
  static const muted = Color(0xFF747B8F);
  static const line = Color(0xFFE2E5EE);
  static const accent = Color(0xFFFF8852);
  static const accentSoft = Color(0xFFFFF1EA);
  static const danger = Color(0xFFE34242);
  static const green = Color(0xFF16A274);
  static const blue = Color(0xFF4D74FF);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.light);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: scheme.copyWith(primary: accent, secondary: slate, surface: surface, error: danger),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: slate, height: 1.05),
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: slate, height: 1.12),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: slate),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: slate),
        bodyLarge: TextStyle(fontSize: 15, color: slate, height: 1.45),
        bodyMedium: TextStyle(fontSize: 13, color: muted, height: 1.45),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        foregroundColor: slate,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: line)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: line)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          elevation: 0,
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          foregroundColor: slate,
          side: const BorderSide(color: line),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
