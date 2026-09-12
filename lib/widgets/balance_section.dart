import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class BalanceSection extends ConsumerWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmountKobo = ref.watch(totalExpensesProvider);
    final totalText = AppUtils.formatCurrency(totalAmountKobo);

    return Column(
      children: [
        16.verticalSpace,
        Container(
          padding: AppPadding.smallSymmetric,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.containerRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCEF175),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              8.horizontalSpace,
              Text(AppStrings.obscuredCard, style: TextStyle(fontSize: 14.spMin)),
              4.horizontalSpace,
              Icon(Icons.keyboard_arrow_down, size: 16.spMin),
            ],
          ),
        ),
        24.verticalSpace,
        Text(
          AppStrings.yourBalance,
          style: TextStyle(color: Colors.black54, fontSize: 14.spMin),
        ),
        8.verticalSpace,
        Text(
          totalText,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        12.verticalSpace,
        Container(
          padding: AppPadding.smallSymmetric,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0FF), // Light purple hint
            borderRadius: BorderRadius.circular(AppConstants.containerRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.savings, size: 14.spMin, color: const Color(0xFF7B61FF)),
              6.horizontalSpace,
              Text(
                AppStrings.savedLastMonth,
                style: TextStyle(
                  fontSize: 12.spMin,
                  color: const Color(0xFF7B61FF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
