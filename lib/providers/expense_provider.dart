import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pebblexpense/core/api_client.dart';
import 'package:pebblexpense/models/expense.dart';

part 'expense_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) { // It's safer to use Ref if ApiClientRef isn't generated, but riverpod_generator normally creates ApiClientRef. Let's use Ref for safety, wait, the generator REQUIRES the specific name or just Ref. Actually, riverpod_generator supports `Ref` now. Let's just use ApiClientRef but we must make sure the generator generates it. Wait, the docs say `Type type(TypeRef ref)`. So `ApiClientRef` should be generated. Let me import `flutter_riverpod` first.
  return ApiClient();
}

@riverpod
class ExpenseList extends _$ExpenseList {
  @override
  Future<List<Expense>> build() async {
    final client = ref.read(apiClientProvider);
    final response = await client.get('/expenses');
    
    final expenses = (response as List).map((e) => Expense.fromJson(e)).toList();
    expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return expenses;
  }

  Future<void> addExpense({
    required String title,
    required int amountKobo,
    required String category,
  }) async {
    final client = ref.read(apiClientProvider);
    
    final newExpenseData = {
      'title': title,
      'amountKobo': amountKobo,
      'category': category,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };

    state = const AsyncValue.loading();
    try {
      final response = await client.post('/expenses', newExpenseData);
      final newExpense = Expense.fromJson(response);
      
      final currentList = state.value ?? [];
      state = AsyncValue.data([newExpense, ...currentList]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExpense(String id) async {
    final client = ref.read(apiClientProvider);
    
    final currentList = state.value ?? [];
    
    state = AsyncValue.data(currentList.where((e) => e.id != id).toList());

    try {
      await client.delete('/expenses/$id');
    } catch (e) {
      state = AsyncValue.data(currentList);
      rethrow;
    }
  }
}

@riverpod
int totalExpenses(Ref ref) { // Using Ref here as well just in case.
  final expenses = ref.watch(expenseListProvider).value ?? [];
  return expenses.fold(0, (sum, expense) => sum + expense.amountKobo);
}
