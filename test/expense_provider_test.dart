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
    final mockResponse = [
      {
        'id': '1',
        'title': 'Test 1',
        'amountKobo': 1000,
        'category': 'Food',
        'createdAt': '2023-10-01T10:00:00Z',
      },
      {
        'id': '2',
        'title': 'Test 2',
        'amountKobo': 2000,
        'category': 'Transport',
        'createdAt': '2023-10-02T10:00:00Z', // newer
      }
    ];
    when(() => mockApiClient.get('/expenses')).thenAnswer((_) async => mockResponse);

    // Act
    // Listen to the provider to trigger initialization
    container.listen(
      expenseListProvider,
      (previous, next) {},
      fireImmediately: true,
    );

    // Wait for the async notifier to build
    final expenses = await container.read(expenseListProvider.future);

    // Assert
    expect(expenses.length, 2);
    // Should be sorted by date descending (Test 2 first)
    expect(expenses.first.id, '2');
    expect(expenses.last.id, '1');
    verify(() => mockApiClient.get('/expenses')).called(1);
  });
}
