import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    // Format amount to Naira (NGN)
    final formatCurrency = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '',
      decimalDigits: 2,
    );
    final amountText = '-₦${formatCurrency.format(expense.amountKobo / 100)}';

    // Format date/time
    final timeText = DateFormat.jm().format(expense.createdAt.toLocal());

    // Generate initial for avatar
    final initial = expense.title.isNotEmpty ? expense.title.substring(0, 1).toUpperCase() : '?';

    // Background color for avatar (in the design, they use dark green or black)
    final isFood = expense.category.toLowerCase() == 'food';
    final avatarColor = isFood ? const Color(0xFFD81B60) : const Color(0xFF1E293B);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarColor,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeText,
                    style: const TextStyle(
                      fontSize: 12,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  expense.category,
                  style: const TextStyle(
                    fontSize: 12,
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
