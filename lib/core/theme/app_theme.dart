import 'package:flutter/material.dart';
import '../constants/ui_constants.dart';

class AppTheme {
  // Cores principais
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA726);
  
  // Cores de fundo
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  
  // Cores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
    ),
    
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: UIConstants.fontXL,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    
    cardTheme: CardTheme(
      elevation: UIConstants.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
      ),
      color: cardColor,
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: UIConstants.elevationM,
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.spacingL,
          vertical: UIConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusM),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: UIConstants.spacingL,
          vertical: UIConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.radiusM),
        ),
        side: const BorderSide(color: primaryColor),
        foregroundColor: primaryColor,
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: UIConstants.spacingM,
        vertical: UIConstants.spacingM,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(UIConstants.radiusM),
        borderSide: const BorderSide(color: errorColor),
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      elevation: UIConstants.elevationM,
      backgroundColor: accentColor,
      foregroundColor: Colors.white,
    ),
    
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade300,
      thickness: 1,
      space: UIConstants.spacingM,
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: UIConstants.fontXXL,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      displayMedium: TextStyle(
        fontSize: UIConstants.fontXL,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: UIConstants.fontL,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: UIConstants.fontM,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: UIConstants.fontL,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: UIConstants.fontM,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: UIConstants.fontS,
        color: textSecondary,
      ),
    ),
  );
}
