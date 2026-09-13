import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pebblexpense/models/create_expense_dto.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/repositories/expense_repository.dart';

part 'expense_provider.g.dart';

@riverpod
class ExpenseList extends _$ExpenseList {
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

    state = AsyncValue.data(currentList.where((e) => e.id != id).toList());

    try {
      await repository.deleteExpense(id);
    } catch (e) {
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

@riverpod
int totalExpenses(Ref ref) {
  final expenses = ref.watch(expenseListProvider).value ?? [];
  return expenses.fold(0, (sum, expense) => sum + expense.amountKobo);
}

@riverpod
Future<Expense> expenseDetail(Ref ref, String id) async {
  final repository = ref.read(expenseRepositoryProvider);
  return repository.getExpenseById(id);
}
