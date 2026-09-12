import 'package:flutter/material.dart';

final Color primaryLime = const Color(0xFFCEF175);
final Color backgroundWhite = const Color(0xFFF7F7F7); // or just white

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF9F9F9),
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryLime,
    primary: primaryLime,
    onPrimary: Colors.black,
    surface: const Color(0xFFF9F9F9),
    onSurface: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF9F9F9),
    foregroundColor: Colors.black,
    elevation: 0,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryLime,
      foregroundColor: Colors.black,
      elevation: 0,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    ),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      color: Colors.black,
      letterSpacing: -1.5,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black54,
    ),
  ),
);
