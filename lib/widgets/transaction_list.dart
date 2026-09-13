import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/widgets/expense_list_item.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class TransactionList extends ConsumerWidget {
  final AsyncValue state;

  const TransactionList({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.when(
      data: (expenses) {
        if (expenses.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: AppPadding.cardInner,
              child: const Center(
                child: Text(AppStrings.noTransactionsYet, style: TextStyle(color: Colors.black54)),
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppPadding.listHeader,
                      child: Text(
                        AppStrings.today,
                        style: TextStyle(
                          fontSize: 12.spMin,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    ExpenseListItem(
                      expense: expenses[0],
                      onTap: () => context.push('/detail/${expenses[0].id}'),
                    ),
                  ],
                );
              }
              final expense = expenses[index];
              return ExpenseListItem(
                expense: expense,
                onTap: () => context.push('/detail/${expense.id}'),
              );
            },
            childCount: expenses.length,
          ),
        );
      },
      loading: () => SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: AppPadding.cardInner,
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Padding(
          padding: AppPadding.cardInner,
          child: Column(
            children: [
              Text('${AppStrings.errorPrefix}$e', textAlign: TextAlign.center),
              16.verticalSpace,
              ElevatedButton(
                onPressed: () => ref.read(expenseListProvider.notifier).refresh(),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
