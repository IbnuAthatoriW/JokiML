// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Theme colors
  static const Color backgroundColor = Color(0xFF090A0F);
  static const Color cardColor = Color(0xFF141722);
  static const Color secondaryCardColor = Color(0xFF1E2230);
  
  static const Color primaryColor = Color(0xFF8B5CF6); // Purple
  static const Color neonBlue = Color(0xFF06B6D4); // Cyan
  static const Color neonPink = Color(0xFFEC4899); // Pink
  static const Color neonGreen = Color(0xFF10B981); // Emerald Green
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color borderCol = Color(0xFF2E354F);

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      cardColor: cardColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: neonBlue,
        surface: cardColor,
        background: backgroundColor,
        error: neonPink,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyLarge: GoogleFonts.inter(textStyle: const TextStyle(color: textPrimary, fontSize: 16)),
        bodyMedium: GoogleFonts.inter(textStyle: const TextStyle(color: textSecondary, fontSize: 14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: secondaryCardColor,
        filled: true,
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderCol, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderCol, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonPink, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: primaryColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // Neon Gradient Box Decoration for Premium gamer cards
  static BoxDecoration neonCardDecoration({
    Color shadowColor = primaryColor,
    double blurRadius = 8.0,
  }) {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: borderCol.withOpacity(0.5),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: shadowColor.withOpacity(0.08),
          offset: const Offset(0, 4),
          blurRadius: blurRadius,
        ),
      ],
    );
  }

  // Glowing Text Style helper
  static TextStyle neonTextStyle({
    required TextStyle baseStyle,
    Color glowColor = neonBlue,
    double glowRadius = 8.0,
  }) {
    return baseStyle.copyWith(
      shadows: [
        Shadow(
          color: glowColor,
          blurRadius: glowRadius,
        ),
      ],
    );
  }
}
