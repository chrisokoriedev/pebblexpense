import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils/utils.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';

class ExpenseDetailHeroCard extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailHeroCard({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final amountText = '-${AppUtils.formatCurrency(expense.amountKobo)}';
    final emoji = AppUtils.getCategoryEmoji(expense.category);
    final categoryName = expense.category ?? 'Other';
    final avatarColor = AppUtils.getAvatarColor(expense.category);
    final accentColor = AppUtils.getCategoryAccentColor(expense.category);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
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
          // Emoji Avatar
          Container(
            width: 72.w,
            height: 72.h,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 34.spMin),
              ),
            ),
          ),
          16.verticalSpace,

          // Amount
          Text(
            amountText,
            style: TextStyle(
              fontSize: 36.spMin,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              color: Colors.black,
            ),
          ),
          8.verticalSpace,

          // Title
          Text(
            expense.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.spMin,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          16.verticalSpace,

          // Category Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: TextStyle(fontSize: 14.spMin)),
                6.horizontalSpace,
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 13.spMin,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
