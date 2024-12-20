import 'package:design_system/theme/colors.dart';
import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  ThemeColors get colors => ThemeColors();
}

ThemeData buildTheme() {
  final colors = ThemeColors();

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: colors.primary,
      onPrimary: const Color(0xFFFFFFFF),
      secondary: colors.secondary,
      onSecondary: const Color(0xFF000000),
      error: const Color(0xFFB22222),
      onError: const Color(0xFFFFFFFF),
      surface: const Color(0xFFF5F5DC),
      onSurface: const Color(0xFF000000),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6F4E37),
      foregroundColor: Color(0xFFFFFFFF),
      centerTitle: true,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6F4E37),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Color(0xFF000000),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Color(0xFF6F4E37),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD2B48C),
        foregroundColor: const Color(0xFF000000),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6F4E37),
      foregroundColor: Color(0xFFFFFFFF),
    ),
  );
}
