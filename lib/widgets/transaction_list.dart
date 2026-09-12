import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text('No transactions yet.', style: TextStyle(color: Colors.black54)),
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Text(
                        'TODAY',
                        style: TextStyle(
                          fontSize: 12,
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
      loading: () => const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Text('Error: $e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(expenseListProvider.notifier).build(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
