import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/widgets/detail_row.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final String expenseId;

  const ExpenseDetailScreen({
    super.key,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if expense is in local list
    final expensesState = ref.watch(expenseListProvider);
    final expense = expensesState.value?.where((e) => e.id == expenseId).firstOrNull;

    if (expense != null) {
      return _buildScaffold(context, ref, expense);
    }

    // Fallback to fetching directly from API by ID
    final detailAsync = ref.watch(expenseDetailProvider(expenseId));
    return detailAsync.when(
      data: (fetchedExpense) => _buildScaffold(context, ref, fetchedExpense),
      loading: () => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.expenseDetails)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text(AppStrings.expenseDetails)),
        body: const Center(child: Text(AppStrings.expenseNotFound)),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref, Expense expense) {
    final amountText = AppUtils.formatCurrency(expense.amountKobo);
    final dateText = AppUtils.formatDateWithTime(expense.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.expenseDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: AppPadding.cardInner,
                child: Column(
                  children: [
                    Text(
                      amountText,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                          ),
                    ),
                    8.verticalSpace,
                    Text(
                      expense.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            24.verticalSpace,
            DetailRow(
              icon: Icons.category,
              label: AppStrings.category,
              value: expense.category ?? 'Other',
            ),
            const Divider(),
            DetailRow(
              icon: Icons.calendar_today,
              label: AppStrings.date,
              value: dateText,
            ),
            const Divider(),
            DetailRow(
              icon: Icons.fingerprint,
              label: AppStrings.id,
              value: expense.id,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteExpenseTitle),
        content: const Text(AppStrings.deleteExpenseContent),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text(AppStrings.cancel, style: TextStyle(color: Colors.black)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => context.pop(true),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(expenseListProvider.notifier).deleteExpense(expenseId);
        if (context.mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.expenseDeleted)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppStrings.failedToDelete}$e')),
          );
        }
      }
    }
  }
}
