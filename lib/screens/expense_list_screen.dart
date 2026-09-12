import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/widgets/top_header.dart';
import 'package:pebblexpense/widgets/balance_section.dart';
import 'package:pebblexpense/widgets/action_row.dart';
import 'package:pebblexpense/widgets/transaction_list.dart';
import 'package:pebblexpense/widgets/mock_bottom_nav_bar.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expenseListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(expenseListProvider.notifier).build(),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: TopHeader()),
              const SliverToBoxAdapter(child: BalanceSection()),
              const SliverToBoxAdapter(child: ActionRow()),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View all >',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TransactionList(state: state),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MockBottomNavBar(),
    );
  }
}
