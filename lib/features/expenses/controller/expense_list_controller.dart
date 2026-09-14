import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pebblexpense/features/expenses/data/models/create_expense_dto.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';
import 'package:pebblexpense/features/expenses/data/repositories/expense_repository.dart';

class ExpenseListController extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    final repository = ref.read(expenseRepositoryProvider);
    return repository.getExpenses();
  }

  Future<void> addExpense({
    required String title,
    required int amountKobo,
    String? category,
  }) async {
    final repository = ref.read(expenseRepositoryProvider);
    final dto = CreateExpenseDto(
      title: title,
      amountKobo: amountKobo,
      category: category,
    );

    final currentList = state.value ?? [];
    final newExpense = await repository.createExpense(dto);

    state = AsyncValue.data([newExpense, ...currentList]);
  }

  Future<void> deleteExpense(String id) async {
    final repository = ref.read(expenseRepositoryProvider);
    final currentList = state.value ?? [];

    // Optimistically remove from state
    state = AsyncValue.data(currentList.where((e) => e.id != id).toList());

    try {
      await repository.deleteExpense(id);
    } catch (e) {
      // Rollback on failure
      state = AsyncValue.data(currentList);
      rethrow;
    }
  }

  Future<void> refresh() async {
    final repository = ref.read(expenseRepositoryProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.getExpenses());
  }
}

final expenseListProvider =
    AsyncNotifierProvider<ExpenseListController, List<Expense>>(
      ExpenseListController.new,
    );

final totalExpensesProvider = Provider<int>((ref) {
  final expenses = ref.watch(expenseListProvider).value ?? [];
  return expenses.fold(0, (sum, expense) => sum + expense.amountKobo);
});

final expenseDetailProvider =
    FutureProvider.family<Expense, String>((ref, id) async {
      final repository = ref.read(expenseRepositoryProvider);
      return repository.getExpenseById(id);
    });
