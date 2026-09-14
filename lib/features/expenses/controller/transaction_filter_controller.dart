import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';

class TransactionFilterState {
  final String searchQuery;
  final String selectedCategory;

  const TransactionFilterState({
    this.searchQuery = '',
    this.selectedCategory = 'All',
  });

  TransactionFilterState copyWith({
    String? searchQuery,
    String? selectedCategory,
  }) {
    return TransactionFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class TransactionFilterController extends Notifier<TransactionFilterState> {
  @override
  TransactionFilterState build() => const TransactionFilterState();

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query.trim().toLowerCase());
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  void reset() {
    state = const TransactionFilterState();
  }
}

final transactionFilterControllerProvider =
    NotifierProvider<TransactionFilterController, TransactionFilterState>(
      TransactionFilterController.new,
    );

final filteredTransactionsProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final expensesAsync = ref.watch(expenseListProvider);
  final filter = ref.watch(transactionFilterControllerProvider);

  return expensesAsync.whenData((expenses) {
    return expenses.where((e) {
      final matchesQuery =
          filter.searchQuery.isEmpty ||
          e.title.toLowerCase().contains(filter.searchQuery);
      final matchesCategory =
          filter.selectedCategory == 'All' ||
          (e.category ?? 'Other') == filter.selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  });
});

final groupedTransactionsProvider =
    Provider<AsyncValue<Map<String, List<Expense>>>>((ref) {
      final filteredAsync = ref.watch(filteredTransactionsProvider);

      return filteredAsync.whenData((expenses) {
        final Map<String, List<Expense>> grouped = {};
        for (final exp in expenses) {
          final dateKey = DateFormat(
            'EEE, d MMM',
          ).format(exp.createdAt.toLocal()).toUpperCase();
          grouped.putIfAbsent(dateKey, () => []).add(exp);
        }
        return grouped;
      });
    });
