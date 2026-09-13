import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/models/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format amount to Naira (NGN) without symbol, since we prepend it
    final amountText = '-${AppUtils.formatCurrency(expense.amountKobo)}';

    // Format date/time
    final timeText = AppUtils.formatTime(expense.createdAt);

    // Generate initial for avatar
    final initial = AppUtils.getInitials(expense.title);

    // Background color for avatar
    final avatarColor = AppUtils.getAvatarColor(expense.category);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: AppPadding.itemSymmetric,
        child: Row(
          children: [
            CircleAvatar(
              radius: AppConstants.listItemAvatarRadius,
              backgroundColor: avatarColor,
              child: Text(
                initial,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.spMin,
                ),
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: TextStyle(
                      fontSize: 16.spMin,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    timeText,
                    style: TextStyle(
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amountText,
                  style: TextStyle(
                    fontSize: 16.spMin,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                4.verticalSpace,
                Text(
                  expense.category ?? 'Other',
                  style: TextStyle(
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
