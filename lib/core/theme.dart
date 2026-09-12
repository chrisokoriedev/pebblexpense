import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final Color primaryLime = const Color(0xFFCEF175);
final Color backgroundWhite = const Color(0xFFF7F7F7); // or just white

ThemeData getAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF9F9F9),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryLime,
      primary: primaryLime,
      onPrimary: Colors.black,
      surface: Colors.white,
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
        borderRadius: BorderRadius.circular(24.r),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLime,
        foregroundColor: Colors.black,
        elevation: 0,
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.spMin),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    ),
    textTheme: TextTheme(
      displayMedium: TextStyle(
        fontSize: 48.spMin,
        fontWeight: FontWeight.w800,
        color: Colors.black,
        letterSpacing: -1.5,
      ),
      titleLarge: TextStyle(
        fontSize: 20.spMin,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      titleMedium: TextStyle(
        fontSize: 16.spMin,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.spMin,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodySmall: TextStyle(
        fontSize: 12.spMin,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
    ),
  );
}
