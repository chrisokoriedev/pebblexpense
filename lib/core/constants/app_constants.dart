import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static const List<int> quickAmounts = [500, 1000, 5000, 10000, 20000];
  static const List<String> categories = ['Food', 'Transport', 'Bills', 'Other'];
  static const String defaultCategory = 'Food';
  
  static const Map<String, String> categoryEmojis = {
    'Food': '🍔',
    'Transport': '🚗',
    'Bills': '💡',
    'Other': '📦',
  };

  static const Map<String, Color> categoryColors = {
    'Food': Color(0xFFFFECEB), // soft warm tint
    'Transport': Color(0xFFE8F1FF), // soft sky tint
    'Bills': Color(0xFFFFF7E6), // soft amber tint
    'Other': Color(0xFFF1EFFF), // soft lavender tint
  };

  static const Map<String, Color> categoryAccentColors = {
    'Food': Color(0xFFE53935),
    'Transport': Color(0xFF1E88E5),
    'Bills': Color(0xFFF57C00),
    'Other': Color(0xFF7E57C2),
  };

  static double get cardRadius => 24.r;
  static double get buttonRadius => 100.r;
  static double get containerRadius => 16.r;
  static double get avatarRadius => 20.r;
  static double get actionAvatarRadius => 28.r;
  static double get listItemAvatarRadius => 24.r;
  static double get bottomNavRadius => 32.r;
}
