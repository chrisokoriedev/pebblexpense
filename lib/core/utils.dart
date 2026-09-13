import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';

class AppUtils {
  /// Converts Kobo to standard Naira format string with commas.
  static String formatCurrency(int amountKobo) {
    final formatCurrency = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatCurrency.format(amountKobo / 100);
  }

  /// Formats raw input number string with commas (e.g. 15000 -> 15,000, 15000.5 -> 15,000.5).
  static String formatInputAmount(String amountStr) {
    if (amountStr.isEmpty) return '0';
    final parts = amountStr.split('.');
    final intPart = parts[0];
    final formattedInt = intPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    if (parts.length > 1) {
      return '$formattedInt.${parts[1]}';
    }
    return formattedInt;
  }

  /// Formats date to a standard time string (e.g., 10:30 AM).
  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time.toLocal());
  }

  /// Formats date with time (e.g., October 1, 2026 10:30 AM).
  static String formatDateWithTime(DateTime time) {
    return DateFormat.yMMMMd().add_jm().format(time.toLocal());
  }

  /// Extracts the initial letter from a title.
  static String getInitials(String title) {
    return title.isNotEmpty ? title.substring(0, 1).toUpperCase() : '?';
  }

  /// Returns the emoji associated with the category.
  static String getCategoryEmoji(String? category) {
    if (category == null) return AppConstants.categoryEmojis['Other'] ?? '📦';
    return AppConstants.categoryEmojis[category] ?? '📦';
  }

  /// Returns a soft pastel background color for category avatars.
  static Color getAvatarColor(String? category) {
    if (category == null) return AppConstants.categoryColors['Other']!;
    return AppConstants.categoryColors[category] ?? AppConstants.categoryColors['Other']!;
  }

  /// Returns an accent color for category highlights.
  static Color getCategoryAccentColor(String? category) {
    if (category == null) return AppConstants.categoryAccentColors['Other']!;
    return AppConstants.categoryAccentColors[category] ?? AppConstants.categoryAccentColors['Other']!;
  }
}
