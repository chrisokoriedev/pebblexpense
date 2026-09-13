import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class CategoryAnalysisScreen extends ConsumerWidget {
  const CategoryAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: expensesAsync.when(
          data: (expenses) {
            if (expenses.isEmpty) {
              return const Center(
                child: Text(
                  'No categories to analyze yet.\nAdd some expenses to see the category breakdown!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              );
            }

            final totalKobo = expenses.fold<int>(0, (sum, e) => sum + e.amountKobo);

            // Compute amounts and counts per category
            final Map<String, int> categoryTotals = {};
            final Map<String, int> categoryCounts = {};
            for (final cat in AppConstants.categories) {
              categoryTotals[cat] = 0;
              categoryCounts[cat] = 0;
            }

            for (final exp in expenses) {
              final cat = exp.category ?? 'Other';
              categoryTotals[cat] = (categoryTotals[cat] ?? 0) + exp.amountKobo;
              categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category Analysis',
                    style: TextStyle(
                      fontSize: 24.spMin,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'Distribution of your spending across categories',
                    style: TextStyle(
                      fontSize: 13.spMin,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  20.verticalSpace,

                  // Segmented Distribution Bar Card (direct recreation from reference screenshot)
                  _SegmentedDistributionCard(
                    categoryTotals: categoryTotals,
                    totalKobo: totalKobo,
                  ),

                  24.verticalSpace,

                  Text(
                    'Category Breakdown',
                    style: TextStyle(
                      fontSize: 18.spMin,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  12.verticalSpace,

                  // Detailed breakdown cards for each category
                  ...AppConstants.categories.map((category) {
                    final amountKobo = categoryTotals[category] ?? 0;
                    final count = categoryCounts[category] ?? 0;
                    final percentage = totalKobo > 0 ? (amountKobo / totalKobo) * 100 : 0.0;
                    final chartColor = AppConstants.categoryChartColors[category] ?? const Color(0xFF4EA5F5);

                    return _CategoryDetailCard(
                      category: category,
                      amountKobo: amountKobo,
                      count: count,
                      percentage: percentage,
                      chartColor: chartColor,
                    );
                  }),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

class _SegmentedDistributionCard extends StatelessWidget {
  final Map<String, int> categoryTotals;
  final int totalKobo;

  const _SegmentedDistributionCard({
    required this.categoryTotals,
    required this.totalKobo,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate non-zero categories for display
    final activeCategories = AppConstants.categories.where((cat) {
      return (categoryTotals[cat] ?? 0) > 0;
    }).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 4),
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
                  fontSize: 16.spMin,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                AppUtils.formatCurrency(totalKobo),
                style: TextStyle(
                  fontSize: 15.spMin,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          18.verticalSpace,

          // Horizontal Segmented Bar (matching reference screenshot)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              height: 28.h,
              child: activeCategories.isEmpty
                  ? Container(color: const Color(0xFFF0F0F2))
                  : Row(
                      children: activeCategories.map((category) {
                        final amount = categoryTotals[category] ?? 0;
                        final flex = totalKobo > 0 ? (amount * 1000 ~/ totalKobo).clamp(1, 1000) : 1;
                        final color = AppConstants.categoryChartColors[category] ?? const Color(0xFF4EA5F5);

                        return Expanded(
                          flex: flex,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),

          16.verticalSpace,

          // Legend chips with percentages (like screenshot: ■ Fashion 52.7%   ■ Transport 21.4%)
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: AppConstants.categories.map((category) {
              final amount = categoryTotals[category] ?? 0;
              final pct = totalKobo > 0 ? (amount / totalKobo) * 100 : 0.0;
              final color = AppConstants.categoryChartColors[category] ?? const Color(0xFF4EA5F5);

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 12.spMin,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  4.horizontalSpace,
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 11.spMin,
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

class _CategoryDetailCard extends StatelessWidget {
  final String category;
  final int amountKobo;
  final int count;
  final double percentage;
  final Color chartColor;

  const _CategoryDetailCard({
    required this.category,
    required this.amountKobo,
    required this.count,
    required this.percentage,
    required this.chartColor,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = AppUtils.getCategoryEmoji(category);
    final avatarBg = AppUtils.getAvatarColor(category);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.containerRadius),
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
                radius: 20.r,
                backgroundColor: avatarBg,
                child: Text(emoji, style: TextStyle(fontSize: 18.spMin)),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 15.spMin,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      '$count ${count == 1 ? "expense" : "expenses"}',
                      style: TextStyle(
                        fontSize: 12.spMin,
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
                    AppUtils.formatCurrency(amountKobo),
                    style: TextStyle(
                      fontSize: 15.spMin,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  2.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: chartColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 11.spMin,
                        fontWeight: FontWeight.w700,
                        color: chartColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          // Progress line
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 5.h,
              backgroundColor: const Color(0xFFF2F2F4),
              valueColor: AlwaysStoppedAnimation<Color>(chartColor),
            ),
          ),
        ],
      ),
    );
  }
}
