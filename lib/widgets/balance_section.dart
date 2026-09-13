import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class BalanceSection extends ConsumerWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmountKobo = ref.watch(totalExpensesProvider);
    final totalText = AppUtils.formatCurrency(totalAmountKobo);
    final expensesCount = ref.watch(expenseListProvider).value?.length ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Spending',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.spMin,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCEF175),
                    borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                  ),
                  child: Text(
                    '$expensesCount ${expensesCount == 1 ? "expense" : "expenses"}',
                    style: TextStyle(
                      fontSize: 11.spMin,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                totalText,
                style: TextStyle(
                  fontSize: 36.spMin,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  color: Colors.black,
                ),
              ),
            ),
            14.verticalSpace,
            Container(
              padding: AppPadding.smallSymmetric,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(AppConstants.containerRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: AppConstants.categories.map((category) {
                  final emoji = AppUtils.getCategoryEmoji(category);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emoji, style: TextStyle(fontSize: 14.spMin)),
                      4.horizontalSpace,
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 11.spMin,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
