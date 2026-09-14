import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/features/category_analysis/presentation/screens/category_analysis_screen.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';
import 'package:pebblexpense/features/expenses/presentation/screens/all_transactions_screen.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/balance_section.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/bottom_nav_bar.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/top_header.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/transaction_list.dart';
import 'package:pebblexpense/features/insights/presentation/screens/insights_screen.dart';

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
            // Tab 0: Home Dashboard
            RefreshIndicator(
              onRefresh: () => ref.read(expenseListProvider.notifier).refresh(),
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
                          GestureDetector(
                            onTap: () => setState(() => _currentTab = 3),
                            child: Text(
                              AppStrings.viewAll,
                              style: TextStyle(
                                fontSize: 13.spMin,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
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
            const InsightsScreen(),
            const CategoryAnalysisScreen(),
            const AllTransactionsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: PulseBottomNavBar(
        currentIndex: _currentTab,
        onTabSelected: (index) => setState(() => _currentTab = index),
        onAddTap: () => context.push('/add'),
      ),
    );
  }
}
