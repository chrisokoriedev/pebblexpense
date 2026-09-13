import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/widgets/delete_expense_modal.dart';
import 'package:pebblexpense/widgets/expense_detail_hero_card.dart';
import 'package:pebblexpense/widgets/expense_info_card.dart';

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
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9F9F9),
          elevation: 0,
          title: const Text('Expense Details', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF9F9F9),
          elevation: 0,
          title: const Text('Expense Details', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.expenseNotFound,
                style: TextStyle(fontSize: 16.spMin, color: Colors.black54),
              ),
              12.verticalSpace,
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref, Expense expense) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Expense Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.spMin,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE), // Soft red
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: const Color(0xFFE53935),
                  size: 20.spMin,
                ),
              ),
              onPressed: () => _handleDelete(context, ref),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          children: [
            // Modular Hero Card Widget
            ExpenseDetailHeroCard(expense: expense),

            20.verticalSpace,

            // Modular Info Card Widget
            ExpenseInfoCard(expense: expense),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await DeleteExpenseModal.show(context);

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
