import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils/utils.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';

class BalanceSection extends ConsumerWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmountKobo = ref.watch(totalExpensesProvider);
    final totalText = AppUtils.formatCurrency(totalAmountKobo);
    final expenses = ref.watch(expenseListProvider).value ?? [];
    final expensesCount = expenses.length;

    // Calculate category totals for mini proportion bar
    final Map<String, int> categoryTotals = {};
    for (final cat in AppConstants.categories) {
      categoryTotals[cat] = 0;
    }
    for (final exp in expenses) {
      final cat = exp.category ?? 'Other';
      categoryTotals[cat] = (categoryTotals[cat] ?? 0) + exp.amountKobo;
    }

    final activeCategories = AppConstants.categories.where((cat) {
      return (categoryTotals[cat] ?? 0) > 0;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Spending',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 13.spMin,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCEF175), // Vibrant Lime matching FAB
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    '$expensesCount ${expensesCount == 1 ? "expense" : "expenses"}',
                    style: TextStyle(
                      fontSize: 11.spMin,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Text(
              totalText,
              style: TextStyle(
                fontSize: 34.spMin,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.0,
                color: Colors.black,
              ),
            ),
            if (activeCategories.isNotEmpty && totalAmountKobo > 0) ...[
              14.verticalSpace,
              // Flat, compact mini proportion bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: SizedBox(
                  height: 6.h,
                  child: Row(
                    children: activeCategories.map((cat) {
                      final amount = categoryTotals[cat] ?? 0;
                      final flex = (amount * 1000 ~/ totalAmountKobo).clamp(
                        1,
                        1000,
                      );
                      final color =
                          AppConstants.categoryChartColors[cat] ??
                          const Color(0xFF4EA5F5);
                      return Expanded(
                        flex: flex,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              8.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget allocation',
                    style: TextStyle(
                      fontSize: 11.spMin,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: activeCategories.take(3).map((cat) {
                      final color =
                          AppConstants.categoryChartColors[cat] ??
                          const Color(0xFF4EA5F5);
                      return Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.r,
                              height: 6.r,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            4.horizontalSpace,
                            Text(
                              cat,
                              style: TextStyle(
                                fontSize: 10.spMin,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
