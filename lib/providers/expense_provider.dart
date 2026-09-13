import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pebblexpense/core/api_client.dart';
import 'package:pebblexpense/models/expense.dart';

part 'expense_provider.g.dart';

@riverpod
ApiClient apiClient(Ref ref) {
  return ApiClient();
}

@riverpod
class ExpenseList extends _$ExpenseList {
  @override
  Future<List<Expense>> build() async {
    final client = ref.read(apiClientProvider);
    final response = await client.get('/api/${client.bucket}/expenses');
    
    final List list;
    if (response is Map<String, dynamic> && response.containsKey('expenses')) {
      list = response['expenses'] as List;
    } else if (response is List) {
      list = response;
    } else {
      list = [];
    }

    final expenses = list.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
    expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return expenses;
  }

  Future<void> addExpense({
    required String title,
    required int amountKobo,
    String? category,
  }) async {
    final client = ref.read(apiClientProvider);
    
    final payload = <String, dynamic>{
      'title': title,
      'amountKobo': amountKobo,
      'category': category,
    };

    final currentList = state.value ?? [];
    
    final response = await client.post('/api/${client.bucket}/expenses', payload);
    final newExpense = Expense.fromJson(response as Map<String, dynamic>);
    
    state = AsyncValue.data([newExpense, ...currentList]);
  }

  Future<void> deleteExpense(String id) async {
    final client = ref.read(apiClientProvider);
    final currentList = state.value ?? [];
    
    state = AsyncValue.data(currentList.where((e) => e.id != id).toList());

    try {
      await client.delete('/api/${client.bucket}/expenses/$id');
    } catch (e) {
      state = AsyncValue.data(currentList);
      rethrow;
    }
  }
}

@riverpod
int totalExpenses(Ref ref) {
  final expenses = ref.watch(expenseListProvider).value ?? [];
  return expenses.fold(0, (sum, expense) => sum + expense.amountKobo);
}

@riverpod
Future<Expense> expenseDetail(Ref ref, String id) async {
  final client = ref.read(apiClientProvider);
  final response = await client.get('/api/${client.bucket}/expenses/$id');
  return Expense.fromJson(response as Map<String, dynamic>);
}
