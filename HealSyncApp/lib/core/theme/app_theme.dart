import 'package:flutter/material.dart';

class AppTheme {
  static const blue = Color(0xFF0D7FD3);
  static const deepBlue = Color(0xFF095AA8);
  static const green = Color(0xFF54C63A);
  static const mint = Color(0xFF8EEA4A);
  static const surface = Color(0xFFF5FCFB);
  static const softBlue = Color(0xFFE8F5FF);
  static const softGreen = Color(0xFFEAFBE8);
  static const ink = Color(0xFF0C2A43);
  static const mutedInk = Color(0xFF35536B);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        primary: blue,
        secondary: green,
        surface: surface,
      ),
      scaffoldBackgroundColor: surface,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        displayLarge: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.4,
        ),
        displayMedium: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        headlineMedium: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
        ),
        headlineSmall: const TextStyle(color: ink, fontWeight: FontWeight.w800),
        titleLarge: const TextStyle(color: ink, fontWeight: FontWeight.w800),
        titleMedium: const TextStyle(color: ink, fontWeight: FontWeight.w700),
        bodyLarge: const TextStyle(
          color: mutedInk,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: const TextStyle(
          color: mutedInk,
          height: 1.45,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: const TextStyle(color: ink, fontWeight: FontWeight.w700),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.92),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: blue.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(
          color: mutedInk,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          color: mutedInk,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: blue.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: blue, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: softGreen,
        side: BorderSide.none,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF63D63E), Color(0xFF16A6DA), Color(0xFF0A5CAB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlow = LinearGradient(
    colors: [Color(0xFFEFFFF5), Color(0xFFEFF8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
