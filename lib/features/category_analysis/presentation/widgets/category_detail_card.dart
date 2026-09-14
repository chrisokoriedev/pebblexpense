import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/utils/utils.dart';
import 'package:pebblexpense/features/category_analysis/controller/category_analysis_controller.dart';

class CategoryDetailCard extends StatelessWidget {
  final CategoryBreakdownItem item;

  const CategoryDetailCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final emoji = AppUtils.getCategoryEmoji(item.category);
    final avatarBg = AppUtils.getAvatarColor(item.category);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: avatarBg,
                child: Text(emoji, style: TextStyle(fontSize: 16.spMin)),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 14.spMin,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      '${item.count} ${item.count == 1 ? "expense" : "expenses"}',
                      style: TextStyle(
                        fontSize: 11.spMin,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppUtils.formatCurrency(item.amountKobo),
                    style: TextStyle(
                      fontSize: 14.spMin,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  2.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: item.chartColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${item.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10.spMin,
                        fontWeight: FontWeight.w700,
                        color: item.chartColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          10.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(3.r),
            child: LinearProgressIndicator(
              value: (item.percentage / 100).clamp(0.0, 1.0),
              minHeight: 4.h,
              backgroundColor: const Color(0xFFF2F2F4),
              valueColor: AlwaysStoppedAnimation<Color>(item.chartColor),
            ),
          ),
        ],
      ),
    );
  }
}
