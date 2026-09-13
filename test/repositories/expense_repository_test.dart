import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pebblexpense/core/api_client.dart';
import 'package:pebblexpense/models/create_expense_dto.dart';
import 'package:pebblexpense/repositories/expense_repository.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late ExpenseRepository repository;

  setUp(() {
    mockApiClient = MockApiClient();
    when(() => mockApiClient.bucket).thenReturn('test_bucket');
    repository = ExpenseRepository(apiClient: mockApiClient);
  });

  group('ExpenseRepository', () {
    test('getExpenses should return expenses sorted by createdAt descending', () async {
      final rawResponse = {
        'expenses': [
          {
            'id': 'exp_old',
            'title': 'Older Expense',
            'amountKobo': 10000,
            'category': 'Food',
            'createdAt': '2026-06-01T10:00:00.000Z',
          },
          {
            'id': 'exp_new',
            'title': 'Newer Expense',
            'amountKobo': 20000,
            'category': 'Transport',
            'createdAt': '2026-06-15T10:00:00.000Z',
          },
        ]
      };

      when(() => mockApiClient.get('/api/test_bucket/expenses'))
          .thenAnswer((_) async => rawResponse);

      final result = await repository.getExpenses();

      expect(result.length, 2);
      expect(result.first.id, 'exp_new');
      expect(result.last.id, 'exp_old');
      verify(() => mockApiClient.get('/api/test_bucket/expenses')).called(1);
    });

    test('getExpenseById should return requested expense', () async {
      final rawExpense = {
        'id': 'exp_1',
        'title': 'Lunch',
        'amountKobo': 250000,
        'category': 'Food',
        'createdAt': '2026-06-20T12:00:00.000Z',
      };

      when(() => mockApiClient.get('/api/test_bucket/expenses/exp_1'))
          .thenAnswer((_) async => rawExpense);

      final result = await repository.getExpenseById('exp_1');

      expect(result.id, 'exp_1');
      expect(result.title, 'Lunch');
      expect(result.amountKobo, 250000);
      verify(() => mockApiClient.get('/api/test_bucket/expenses/exp_1')).called(1);
    });

    test('createExpense should post dto and return created expense', () async {
      const dto = CreateExpenseDto(
        title: 'New Shoes',
        amountKobo: 500000,
        category: 'Bills',
      );

      final createdResponse = {
        'id': 'exp_new_created',
        'title': 'New Shoes',
        'amountKobo': 500000,
        'category': 'Bills',
        'createdAt': '2026-06-30T10:00:00.000Z',
      };

      when(() => mockApiClient.post(
            '/api/test_bucket/expenses',
            dto.toJson(),
          )).thenAnswer((_) async => createdResponse);

      final result = await repository.createExpense(dto);

      expect(result.id, 'exp_new_created');
      expect(result.title, 'New Shoes');
      expect(result.amountKobo, 500000);
      verify(() => mockApiClient.post('/api/test_bucket/expenses', dto.toJson())).called(1);
    });

    test('deleteExpense should invoke delete endpoint', () async {
      when(() => mockApiClient.delete('/api/test_bucket/expenses/exp_to_delete'))
          .thenAnswer((_) async => null);

      await repository.deleteExpense('exp_to_delete');

      verify(() => mockApiClient.delete('/api/test_bucket/expenses/exp_to_delete')).called(1);
    });

    test('should rethrow ApiException when API client throws', () async {
      when(() => mockApiClient.get('/api/test_bucket/expenses'))
          .thenThrow(ApiException('internal error', statusCode: 500));

      expect(
        () => repository.getExpenses(),
        throwsA(isA<ApiException>().having((e) => e.message, 'message', 'internal error')),
      );
    });
  });
}
