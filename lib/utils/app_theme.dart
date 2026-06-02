// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF1A8C6E);
  static const Color primaryDark = Color(0xFF0F5C48);
  static const Color primaryLight = Color(0xFF4DB898);
  static const Color accent = Color(0xFFD4AF37);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceElevated = Color(0xFF1E1E1E);
  static const Color surfaceCard = Color(0xFF252525);
  static const Color onSurface = Color(0xFFECECEC);
  static const Color onSurfaceSecondary = Color(0xFF9E9E9E);
  static const Color divider = Color(0xFF2E2E2E);
  static const Color error = Color(0xFFCF6679);

  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: onSurface,
    letterSpacing: -0.5,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: onSurface,
    letterSpacing: 0.1,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: onSurfaceSecondary,
  );

  static const TextStyle arabicText = TextStyle(
    fontSize: 22,
    color: accent,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: onSurfaceSecondary,
    letterSpacing: 0.3,
  );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: accent,
          surface: surface,
          error: error,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: onSurface,
        ),
        scaffoldBackgroundColor: surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
          titleTextStyle: titleLarge,
          iconTheme: IconThemeData(color: onSurface),
        ),
        cardTheme: CardThemeData(
          color: surfaceCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dividerColor: divider,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceElevated,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: onSurfaceSecondary),
          prefixIconColor: onSurfaceSecondary,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: primary,
          inactiveTrackColor: primary.withOpacity(0.25),
          thumbColor: primaryLight,
          overlayColor: primary.withOpacity(0.2),
          trackHeight: 3,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      );
}
