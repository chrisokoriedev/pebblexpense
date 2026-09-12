import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
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
                          fontSize: 14.spMin,
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
