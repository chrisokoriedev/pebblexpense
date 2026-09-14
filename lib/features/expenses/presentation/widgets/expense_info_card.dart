import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils/utils.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';

class ExpenseInfoCard extends StatelessWidget {
  final Expense expense;

  const ExpenseInfoCard({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final dateText = AppUtils.formatDateWithTime(expense.createdAt);
    final emoji = AppUtils.getCategoryEmoji(expense.category);
    final categoryName = expense.category ?? 'Other';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Information',
            style: TextStyle(
              fontSize: 15.spMin,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          16.verticalSpace,

          _InfoItemRow(
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF4CAF50),
            label: 'Status',
            value: 'Completed',
            valueColor: const Color(0xFF2E7D32),
          ),
          const Divider(height: 24, color: Color(0xFFF0F0F0)),

          _InfoItemRow(
            icon: Icons.calendar_today_rounded,
            iconColor: Colors.black54,
            label: 'Date & Time',
            value: dateText,
          ),
          const Divider(height: 24, color: Color(0xFFF0F0F0)),

          _InfoItemRow(
            icon: Icons.category_rounded,
            iconColor: Colors.black54,
            label: 'Category',
            value: '$emoji $categoryName',
          ),
          const Divider(height: 24, color: Color(0xFFF0F0F0)),

          _InfoItemRow(
            icon: Icons.tag_rounded,
            iconColor: Colors.black54,
            label: 'Transaction ID',
            value: expense.id,
            isId: true,
            onCopy: () {
              Clipboard.setData(ClipboardData(text: expense.id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction ID copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoItemRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isId;
  final VoidCallback? onCopy;

  const _InfoItemRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
    this.isId = false,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.spMin, color: iconColor),
        12.horizontalSpace,
        Text(
          label,
          style: TextStyle(
            fontSize: 14.spMin,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (isId)
          GestureDetector(
            onTap: onCopy,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.spMin,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: Colors.black87,
                  ),
                ),
                6.horizontalSpace,
                Icon(
                  Icons.copy_rounded,
                  size: 16.spMin,
                  color: Colors.black45,
                ),
              ],
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: 14.spMin,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Colors.black87,
            ),
          ),
      ],
    );
  }
}
