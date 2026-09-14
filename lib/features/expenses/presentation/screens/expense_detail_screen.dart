import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/delete_expense_modal.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/expense_detail_hero_card.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/expense_info_card.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final String expenseId;

  const ExpenseDetailScreen({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesState = ref.watch(expenseListProvider);
    final expense = expensesState.value?.where((e) => e.id == expenseId).firstOrNull;

    if (expense != null) return _buildScaffold(context, ref, expense);

    final detailAsync = ref.watch(expenseDetailProvider(expenseId));
    return detailAsync.when(
      data: (fetched) => _buildScaffold(context, ref, fetched),
      loading: () => _buildStatusScaffold(context, const CircularProgressIndicator()),
      error: (error, _) => _buildStatusScaffold(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.expenseNotFound, style: TextStyle(fontSize: 16.spMin, color: Colors.black54)),
            12.verticalSpace,
            ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusScaffold(BuildContext context, Widget child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        title: const Text('Expense Details', style: TextStyle(color: Colors.black)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black), onPressed: () => context.pop()),
      ),
      body: Center(child: child),
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
        title: Text('Expense Details', style: TextStyle(color: Colors.black, fontSize: 18.spMin, fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(color: Color(0xFFFFEBEE), shape: BoxShape.circle),
                child: Icon(Icons.delete_outline_rounded, color: const Color(0xFFE53935), size: 20.spMin),
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
            ExpenseDetailHeroCard(expense: expense),
            20.verticalSpace,
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.expenseDeleted)));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppStrings.failedToDelete}$e')));
        }
      }
    }
  }
}
