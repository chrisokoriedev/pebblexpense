import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/features/expenses/data/models/expense.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/expense_list_item.dart';

class TransactionGroupedList extends StatelessWidget {
  final Map<String, List<Expense>> grouped;
  final String query;

  const TransactionGroupedList({
    super.key,
    required this.grouped,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    if (grouped.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Column(
              children: [
                Icon(
                  query.isNotEmpty
                      ? Icons.search_off_rounded
                      : Icons.receipt_long_rounded,
                  size: 42.spMin,
                  color: Colors.black26,
                ),
                12.verticalSpace,
                Text(
                  query.isNotEmpty
                      ? 'No transactions found for "$query"'
                      : 'No transactions in this category',
                  style: TextStyle(
                    fontSize: 13.spMin,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: grouped.length,
      itemBuilder: (context, i) {
        final dateHeader = grouped.keys.elementAt(i);
        final items = grouped[dateHeader]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 6.h),
              child: Text(
                dateHeader,
                style: TextStyle(
                  fontSize: 11.spMin,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Colors.black45,
                ),
              ),
            ),
            ...items.map(
              (e) => ExpenseListItem(
                expense: e,
                onTap: () => context.push('/detail/${e.id}'),
              ),
            ),
          ],
        );
      },
    );
  }
}
