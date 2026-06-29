import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0A091E);
  static const surface = Color(0xFF14122C);
  static const surfaceAlt = Color(0xFF1D1A3F);
  static const surfaceSoft = Color(0xFF25224D);
  static const primary = Color(0xFF4D62FE);
  static const secondary = Color(0xFFC04CFD);
  static const highlight = Color(0xFFFFD600);
  static const border = Color(0xFF373177);

  // Gradient helper for gaming aesthetic buttons and accents
  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
