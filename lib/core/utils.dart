import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  /// Converts Kobo to standard Naira format string.
  static String formatCurrency(int amountKobo) {
    final formatCurrency = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    return formatCurrency.format(amountKobo / 100);
  }

  /// Formats date to a standard time string (e.g., 10:30 AM).
  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time.toLocal());
  }

  /// Formats date with time (e.g., October 1, 2023 10:30 AM).
  static String formatDateWithTime(DateTime time) {
    return DateFormat.yMMMMd().add_jm().format(time.toLocal());
  }

  /// Extracts the initial letter from a title.
  static String getInitials(String title) {
    return title.isNotEmpty ? title.substring(0, 1).toUpperCase() : '?';
  }

  /// Returns an avatar background color based on category.
  static Color getAvatarColor(String category) {
    final isFood = category.toLowerCase() == 'food';
    return isFood ? const Color(0xFFD81B60) : const Color(0xFF1E293B);
  }
}
