import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:precious/resources/app_export.dart';

/// Custom app theme follow with Material3
/// 
/// References: https://m3.material.io/
class AppTheme {
  static final themeLight = ThemeData(
    textTheme: textTheme,
    fontFamily: GoogleFonts.rubik().fontFamily
  );

  static final textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.fSize,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    headlineMedium: TextStyle(
      fontSize: 28.fSize,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    titleLarge: TextStyle(
      fontSize: 22.fSize,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    titleMedium: TextStyle(
      fontSize: 16.fSize,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    bodyLarge: TextStyle(
      fontSize: 16.fSize,
      fontWeight: FontWeight.normal,
      color: Colors.grey
    ),
    bodyMedium: TextStyle(
      fontSize: 14.fSize,
      fontWeight: FontWeight.normal,
      color: Colors.grey
    ),
    labelLarge: TextStyle(
      fontSize: 14.fSize,
      color: Colors.white
    ),
    labelMedium: TextStyle(
      fontSize: 12.fSize,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontSize: 11.fSize,
      color: Colors.white,
    ),
  );
}
