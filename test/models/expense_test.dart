import 'package:flutter_test/flutter_test.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/models/create_expense_dto.dart';

void main() {
  group('Expense Model', () {
    test('should correctly deserialize from JSON', () {
      final json = {
        'id': 'exp_a1b2c3d4',
        'title': 'Bolt to office',
        'amountKobo': 320000,
        'category': 'Transport',
        'createdAt': '2026-06-20T08:14:00.000Z',
      };

      final expense = Expense.fromJson(json);

      expect(expense.id, 'exp_a1b2c3d4');
      expect(expense.title, 'Bolt to office');
      expect(expense.amountKobo, 320000);
      expect(expense.category, 'Transport');
      expect(expense.createdAt, DateTime.parse('2026-06-20T08:14:00.000Z'));
      expect(expense.formattedAmount, '3200.00');
    });

    test('should support null category in JSON', () {
      final json = {
        'id': 'exp_misc1',
        'title': 'Random Item',
        'amountKobo': 50000,
        'category': null,
        'createdAt': '2026-06-21T10:00:00.000Z',
      };

      final expense = Expense.fromJson(json);

      expect(expense.category, isNull);
      expect(expense.formattedAmount, '500.00');
    });

    test('should correctly serialize to JSON', () {
      final expense = Expense(
        id: 'exp_test123',
        title: 'Groceries',
        amountKobo: 1255050,
        category: 'Food',
        createdAt: DateTime.parse('2026-06-21T17:02:00.000Z'),
      );

      final json = expense.toJson();

      expect(json['id'], 'exp_test123');
      expect(json['title'], 'Groceries');
      expect(json['amountKobo'], 1255050);
      expect(json['category'], 'Food');
      expect(json['createdAt'], '2026-06-21T17:02:00.000Z');
    });
  });

  group('CreateExpenseDto', () {
    test('should serialize to JSON without id or createdAt', () {
      const dto = CreateExpenseDto(
        title: 'Lunch with team',
        amountKobo: 450000,
        category: 'Food',
      );

      final json = dto.toJson();

      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('createdAt'), isFalse);
      expect(json['title'], 'Lunch with team');
      expect(json['amountKobo'], 450000);
      expect(json['category'], 'Food');
    });
  });
}
