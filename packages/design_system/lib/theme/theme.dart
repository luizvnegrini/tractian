import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      package: 'design_system',
      colorScheme: const ColorScheme.light(
        primary: ThemeColors.primary,
        secondary: ThemeColors.secondary,
        surface: ThemeColors.surface,
      ),
      scaffoldBackgroundColor: ThemeColors.scaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeColors.appBarBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: ThemeColors.appBarIcon),
        titleTextStyle: TextStyle(
          color: ThemeColors.appBarTitle,
          fontSize: 20,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: ThemeColors.chipSelected,
        labelStyle: const TextStyle(color: ThemeColors.chipLabel),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: ThemeColors.chipBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColors.buttonBackground,
          foregroundColor: ThemeColors.buttonForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        fillColor: ThemeColors.inputFill,
        filled: true,
        prefixIconColor: ThemeColors.inputPrefixIcon,
        hintStyle: const TextStyle(
          color: ThemeColors.inputHint,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: const DividerThemeData(
        color: ThemeColors.divider,
      ),
    );
  }
}
