import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils/utils.dart';
import 'package:pebblexpense/features/category_analysis/controller/category_analysis_controller.dart';

class SegmentedDistributionCard extends StatelessWidget {
  final CategoryAnalysisData data;

  const SegmentedDistributionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
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
                'Spending Proportion',
                style: TextStyle(
                  fontSize: 15.spMin,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                AppUtils.formatCurrency(data.totalKobo),
                style: TextStyle(
                  fontSize: 14.spMin,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Horizontal Segmented Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 22.h,
              child: data.activeCategories.isEmpty
                  ? Container(color: const Color(0xFFF0F0F2))
                  : Row(
                      children: data.activeCategories.map((category) {
                        final amount = data.categoryTotals[category] ?? 0;
                        final flex = data.totalKobo > 0
                            ? (amount * 1000 ~/ data.totalKobo).clamp(1, 1000)
                            : 1;
                        final color =
                            AppConstants.categoryChartColors[category] ??
                            const Color(0xFF4EA5F5);

                        return Expanded(
                          flex: flex,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),

          14.verticalSpace,

          // Legend chips with percentages
          Wrap(
            spacing: 14.w,
            runSpacing: 6.h,
            children: AppConstants.categories.map((category) {
              final amount = data.categoryTotals[category] ?? 0;
              final pct = data.totalKobo > 0
                  ? (amount / data.totalKobo) * 100
                  : 0.0;
              final color =
                  AppConstants.categoryChartColors[category] ??
                  const Color(0xFF4EA5F5);

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 11.5.spMin,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  4.horizontalSpace,
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 10.5.spMin,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
