import 'package:flutter/material.dart';
import '../constants/ui_constants.dart';

class AppTheme {
  // CORES
  static const Color navyBlue = Color(0xFF002B5B);
  static const Color turquoise = Color(0xFF00C8D7);

  static const Color backgroundColor = Color(0xFFF4F8FB);
  static const Color surfaceColor = Colors.white;

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4F4F4F);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // CORES BASE
    primaryColor: navyBlue,
    colorScheme: const ColorScheme.light(
      primary: navyBlue,
      secondary: turquoise,
      surface: Colors.white,
      error: Color(0xFFD32F2F),
    ),

    scaffoldBackgroundColor: backgroundColor,

    // APP BAR
    appBarTheme: const AppBarTheme(
      backgroundColor: navyBlue,
      foregroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      titleSpacing: UIConstants.spacingL,
      titleTextStyle: TextStyle(
        fontSize: UIConstants.fontXL,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    // CARTÕES / CARDS
    cardTheme: const CardTheme(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      margin: EdgeInsets.all(UIConstants.spacingM),
    ),

    // BOTÃO TEXTO (GRANDE)
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(navyBlue),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(
            vertical: UIConstants.spacingL,
            horizontal: UIConstants.spacingXL,
          ),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: UIConstants.fontM,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),

    // BOTÃO PREENCHIDO (FILLED) — igual ao ElevatedButton
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: navyBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(
          vertical: UIConstants.spacingL,
          horizontal: UIConstants.spacingXL,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        textStyle: const TextStyle(
          fontSize: UIConstants.fontL,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // BOTÃO ELEVADO (GRANDE)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: navyBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        padding: const EdgeInsets.symmetric(
          vertical: UIConstants.spacingL,
          horizontal: UIConstants.spacingXL,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        textStyle: const TextStyle(
          fontSize: UIConstants.fontL,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    // BOTÃO CONTORNADO
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: navyBlue, width: 2),
        padding: const EdgeInsets.symmetric(
          vertical: UIConstants.spacingL,
          horizontal: UIConstants.spacingXL,
        ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        foregroundColor: navyBlue,
        textStyle: const TextStyle(
          fontSize: UIConstants.fontM,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // INPUTS / CAMPOS DE TEXTO
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingL,
        vertical: UIConstants.spacingL,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: turquoise, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.red),
      ),
    ),

    // FLOATING BUTTON
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: turquoise,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    // DIVISOR
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
      space: UIConstants.spacingM,
    ),

    // TIPOGRAFIA
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 18, color: textPrimary),
      bodyMedium: TextStyle(fontSize: 16, color: textPrimary),
      bodySmall: TextStyle(fontSize: 14, color: textSecondary),
    ),
  );
}
