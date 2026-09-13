import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pebblexpense/core/api_client.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ProviderContainer container;

  setUp(() {
    mockApiClient = MockApiClient();
    when(() => mockApiClient.bucket).thenReturn('amaka');
    container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(mockApiClient),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('fetch expenses successfully and sort by descending date', () async {
    // Arrange
    final mockResponse = {
      'expenses': [
        {
          'id': 'exp_1',
          'title': 'Test 1',
          'amountKobo': 1000,
          'category': 'Food',
          'createdAt': '2026-06-20T10:00:00Z',
        },
        {
          'id': 'exp_2',
          'title': 'Test 2',
          'amountKobo': 2000,
          'category': 'Transport',
          'createdAt': '2026-06-21T10:00:00Z', // newer
        }
      ]
    };
    when(() => mockApiClient.get('/api/amaka/expenses'))
        .thenAnswer((_) async => mockResponse);

    // Act
    container.listen(
      expenseListProvider,
      (previous, next) {},
      fireImmediately: true,
    );

    final expenses = await container.read(expenseListProvider.future);

    // Assert
    expect(expenses.length, 2);
    expect(expenses.first.id, 'exp_2');
    expect(expenses.last.id, 'exp_1');
    verify(() => mockApiClient.get('/api/amaka/expenses')).called(1);
  });

  test('add expense creates item and updates list state', () async {
    // Arrange initial list
    when(() => mockApiClient.get('/api/amaka/expenses')).thenAnswer((_) async => {
          'expenses': [],
        });

    final createdItem = {
      'id': 'exp_created',
      'title': 'Coffee',
      'amountKobo': 150000,
      'category': 'Food',
      'createdAt': '2026-06-30T10:45:00Z',
    };

    when(() => mockApiClient.post('/api/amaka/expenses', {
          'title': 'Coffee',
          'amountKobo': 150000,
          'category': 'Food',
        })).thenAnswer((_) async => createdItem);

    // Initialize list
    await container.read(expenseListProvider.future);

    // Act
    await container.read(expenseListProvider.notifier).addExpense(
          title: 'Coffee',
          amountKobo: 150000,
          category: 'Food',
        );

    // Assert
    final state = container.read(expenseListProvider).value!;
    expect(state.length, 1);
    expect(state.first.id, 'exp_created');
    expect(state.first.title, 'Coffee');
    expect(state.first.amountKobo, 150000);
  });

  test('delete expense removes item from list', () async {
    // Arrange
    when(() => mockApiClient.get('/api/amaka/expenses')).thenAnswer((_) async => {
          'expenses': [
            {
              'id': 'exp_del',
              'title': 'To Delete',
              'amountKobo': 50000,
              'category': 'Bills',
              'createdAt': '2026-06-25T12:00:00Z',
            }
          ],
        });

    when(() => mockApiClient.delete('/api/amaka/expenses/exp_del'))
        .thenAnswer((_) async => null);

    await container.read(expenseListProvider.future);
    expect(container.read(expenseListProvider).value!.length, 1);

    // Act
    await container.read(expenseListProvider.notifier).deleteExpense('exp_del');

    // Assert
    expect(container.read(expenseListProvider).value!.isEmpty, isTrue);
    verify(() => mockApiClient.delete('/api/amaka/expenses/exp_del')).called(1);
  });

  test('expenseDetail fetches single expense by id', () async {
    // Arrange
    final mockExpense = {
      'id': 'exp_single',
      'title': 'Single Detail',
      'amountKobo': 250000,
      'category': 'Transport',
      'createdAt': '2026-06-20T08:14:00Z',
    };

    when(() => mockApiClient.get('/api/amaka/expenses/exp_single'))
        .thenAnswer((_) async => mockExpense);

    // Act
    final expense = await container.read(expenseDetailProvider('exp_single').future);

    // Assert
    expect(expense.id, 'exp_single');
    expect(expense.title, 'Single Detail');
    expect(expense.amountKobo, 250000);
  });
}
