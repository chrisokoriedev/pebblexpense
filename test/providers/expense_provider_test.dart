import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pebblexpense/models/create_expense_dto.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/repositories/expense_repository.dart';

class MockExpenseRepository extends Mock implements IExpenseRepository {}
class FakeCreateExpenseDto extends Fake implements CreateExpenseDto {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCreateExpenseDto());
  });

  late MockExpenseRepository mockRepository;
  late ProviderContainer container;

  final sampleExpense1 = Expense(
    id: 'exp_1',
    title: 'Uber to airport',
    amountKobo: 500000,
    category: 'Transport',
    createdAt: DateTime.parse('2026-06-20T10:00:00.000Z'),
  );

  final sampleExpense2 = Expense(
    id: 'exp_2',
    title: 'Dinner',
    amountKobo: 350000,
    category: 'Food',
    createdAt: DateTime.parse('2026-06-19T10:00:00.000Z'),
  );

  setUp(() {
    mockRepository = MockExpenseRepository();
    container = ProviderContainer(
      overrides: [
        expenseRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ExpenseList Provider', () {
    test('initial state loads expenses from repository', () async {
      when(() => mockRepository.getExpenses())
          .thenAnswer((_) async => [sampleExpense1, sampleExpense2]);

      final expenses = await container.read(expenseListProvider.future);

      expect(expenses.length, 2);
      expect(expenses.first.id, 'exp_1');
      expect(expenses.last.id, 'exp_2');
    });

    test('addExpense adds new item to top of list without full reload', () async {
      when(() => mockRepository.getExpenses())
          .thenAnswer((_) async => [sampleExpense1]);

      // Initialize list
      await container.read(expenseListProvider.future);

      final newExpense = Expense(
        id: 'exp_3',
        title: 'Electricity bill',
        amountKobo: 1200000,
        category: 'Bills',
        createdAt: DateTime.parse('2026-06-21T12:00:00.000Z'),
      );

      when(() => mockRepository.createExpense(any()))
          .thenAnswer((_) async => newExpense);

      await container.read(expenseListProvider.notifier).addExpense(
            title: 'Electricity bill',
            amountKobo: 1200000,
            category: 'Bills',
          );

      final updatedList = container.read(expenseListProvider).value!;

      expect(updatedList.length, 2);
      expect(updatedList.first.id, 'exp_3');
      expect(updatedList[1].id, 'exp_1');
      // Verify getExpenses was not called again (no full reload)
      verify(() => mockRepository.getExpenses()).called(1);
    });

    test('deleteExpense optimistically removes item and rolls back on failure', () async {
      when(() => mockRepository.getExpenses())
          .thenAnswer((_) async => [sampleExpense1, sampleExpense2]);

      await container.read(expenseListProvider.future);

      // Simulate failure in repository
      when(() => mockRepository.deleteExpense('exp_1'))
          .thenThrow(Exception('Network failure'));

      expect(
        () => container.read(expenseListProvider.notifier).deleteExpense('exp_1'),
        throwsException,
      );

      // Verify that after catching error, list rolls back
      final rolledBackList = container.read(expenseListProvider).value!;
      expect(rolledBackList.length, 2);
      expect(rolledBackList.first.id, 'exp_1');
    });

    test('deleteExpense successfully deletes item', () async {
      when(() => mockRepository.getExpenses())
          .thenAnswer((_) async => [sampleExpense1, sampleExpense2]);

      await container.read(expenseListProvider.future);

      when(() => mockRepository.deleteExpense('exp_1'))
          .thenAnswer((_) async {});

      await container.read(expenseListProvider.notifier).deleteExpense('exp_1');

      final remainingList = container.read(expenseListProvider).value!;
      expect(remainingList.length, 1);
      expect(remainingList.first.id, 'exp_2');
    });
  });

  group('totalExpensesProvider', () {
    test('computes sum of amountKobo for all expenses', () async {
      when(() => mockRepository.getExpenses())
          .thenAnswer((_) async => [sampleExpense1, sampleExpense2]);

      await container.read(expenseListProvider.future);

      final total = container.read(totalExpensesProvider);

      // 500000 + 350000 = 850000 kobo (₦8,500.00)
      expect(total, 850000);
    });
  });
}
