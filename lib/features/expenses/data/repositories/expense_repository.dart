import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pebblexpense/core/constants/api_endpoints.dart';
import 'package:pebblexpense/core/network/api_client.dart';
import 'package:pebblexpense/features/expenses/data/models/create_expense_dto.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';
import 'package:pebblexpense/features/expenses/data/models/expenses_response.dart';

abstract class IExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<Expense> getExpenseById(String id);
  Future<Expense> createExpense(CreateExpenseDto dto);
  Future<void> deleteExpense(String id);
}

class ExpenseRepository implements IExpenseRepository {
  final ApiClient _apiClient;

  ExpenseRepository({required this._apiClient});

  @override
  Future<List<Expense>> getExpenses() async {
    final response = await _apiClient.get(
      ApiEndpoints.expenses(_apiClient.bucket),
    );
    final expensesResponse = ExpensesResponse.fromJson(
      response as Map<String, dynamic>,
    );
    final expenses = List<Expense>.from(expensesResponse.expenses);
    expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return expenses;
  }

  @override
  Future<Expense> getExpenseById(String id) async {
    final response = await _apiClient.get(
      ApiEndpoints.expenseById(_apiClient.bucket, id),
    );
    return Expense.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<Expense> createExpense(CreateExpenseDto dto) async {
    final response = await _apiClient.post(
      ApiEndpoints.expenses(_apiClient.bucket),
      dto.toJson(),
    );
    return Expense.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _apiClient.delete(ApiEndpoints.expenseById(_apiClient.bucket, id));
  }
}

final expenseRepositoryProvider = Provider<IExpenseRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ExpenseRepository(apiClient: client);
});
