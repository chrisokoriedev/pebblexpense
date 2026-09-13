import 'package:flutter_test/flutter_test.dart';
import 'package:pebblexpense/core/utils.dart';

void main() {
  group('AppUtils.formatCurrency', () {
    test('should format 0 kobo as ₦0.00', () {
      expect(AppUtils.formatCurrency(0), '₦0.00');
    });

    test('should format 320000 kobo as ₦3,200.00', () {
      expect(AppUtils.formatCurrency(320000), '₦3,200.00');
    });

    test('should format 1255050 kobo as ₦12,550.50', () {
      expect(AppUtils.formatCurrency(1255050), '₦12,550.50');
    });

    test('should format 100 kobo as ₦1.00', () {
      expect(AppUtils.formatCurrency(100), '₦1.00');
    });
  });

  group('AppUtils.formatInputAmount', () {
    test('should return 0 for empty string', () {
      expect(AppUtils.formatInputAmount(''), '0');
    });

    test('should format numbers with thousand separators', () {
      expect(AppUtils.formatInputAmount('15000'), '15,000');
      expect(AppUtils.formatInputAmount('1000000'), '1,000,000');
    });

    test('should preserve decimal points', () {
      expect(AppUtils.formatInputAmount('15000.5'), '15,000.5');
      expect(AppUtils.formatInputAmount('15000.50'), '15,000.50');
    });
  });

  group('AppUtils.getInitials', () {
    test('should return initial uppercase letter', () {
      expect(AppUtils.getInitials('Uber'), 'U');
      expect(AppUtils.getInitials('groceries'), 'G');
    });

    test('should return ? for empty string', () {
      expect(AppUtils.getInitials(''), '?');
    });
  });

  group('AppUtils Category Helpers', () {
    test('should return valid category emojis', () {
      expect(AppUtils.getCategoryEmoji('Food'), '🍔');
      expect(AppUtils.getCategoryEmoji('Transport'), '🚗');
      expect(AppUtils.getCategoryEmoji('Bills'), '📄');
      expect(AppUtils.getCategoryEmoji('Other'), '📦');
      expect(AppUtils.getCategoryEmoji(null), '📦');
      expect(AppUtils.getCategoryEmoji('Unknown'), '📦');
    });
  });
}
