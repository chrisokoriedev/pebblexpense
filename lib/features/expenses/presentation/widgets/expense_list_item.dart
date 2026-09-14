import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/utils/utils.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';

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
    // Format amount with currency symbol
    final amountText = '-${AppUtils.formatCurrency(expense.amountKobo)}';

    // Format date/time
    final timeText = AppUtils.formatDateWithTime(expense.createdAt);

    // Get emoji and background color for avatar
    final emoji = AppUtils.getCategoryEmoji(expense.category);
    final avatarColor = AppUtils.getAvatarColor(expense.category);
    final categoryName = expense.category ?? 'Other';

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
                emoji,
                style: TextStyle(
                  fontSize: 22.spMin,
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
                      color: Colors.black45,
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
                  categoryName,
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
