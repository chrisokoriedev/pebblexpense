import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/screens/stats_screen.dart';
import 'package:pebblexpense/widgets/top_header.dart';
import 'package:pebblexpense/widgets/balance_section.dart';
import 'package:pebblexpense/widgets/transaction_list.dart';
import 'package:pebblexpense/widgets/bottom_nav_bar.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(expenseListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: IndexedStack(
          index: _currentTab,
          children: [
            // Tab 0: Home Expense List
            RefreshIndicator(
              onRefresh: () => ref.read(expenseListProvider.notifier).build(),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: TopHeader()),
                  const SliverToBoxAdapter(child: BalanceSection()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.transactionHistory,
                            style: TextStyle(
                              fontSize: 18.spMin,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.viewAll,
                            style: TextStyle(
                              fontSize: 13.spMin,
                              color: Colors.black45,
                              fontWeight: FontWeight.w600,
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

            // Tab 1: Stats Screen
            const StatsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: PulseBottomNavBar(
        currentIndex: _currentTab,
        onTabSelected: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        onAddTap: () => context.push('/add'),
      ),
    );
  }
}
