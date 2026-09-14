import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class CategoryAnalysisScreen extends ConsumerWidget {
  const CategoryAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(expenseListProvider.notifier).refresh(),
          child: expensesAsync.when(
            data: (expenses) {
              if (expenses.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 120.h),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline_rounded, size: 48.spMin, color: Colors.black26),
                          12.verticalSpace,
                          Text(
                            'No categories to analyze yet.\nAdd some expenses to see the breakdown!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13.spMin, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category Analysis',
                      style: TextStyle(
                        fontSize: 22.spMin,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      'Distribution of your spending across categories',
                      style: TextStyle(
                        fontSize: 12.spMin,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    16.verticalSpace,

                    // Segmented Proportion Bar Card
                    _SegmentedDistributionCard(
                      categoryTotals: categoryTotals,
                      totalKobo: totalKobo,
                    ),

                    20.verticalSpace,

                    Text(
                      'Category Breakdown',
                      style: TextStyle(
                        fontSize: 16.spMin,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    10.verticalSpace,

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
            error: (e, _) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 120.h),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.w),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEBEE),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.wifi_off_rounded,
                            size: 32.spMin,
                            color: const Color(0xFFE53935),
                          ),
                        ),
                        12.verticalSpace,
                        Text(
                          'Connection Error',
                          style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w700),
                        ),
                        6.verticalSpace,
                        Text(
                          'Could not load categories. Check your connection and retry.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.spMin, color: Colors.black54),
                        ),
                        16.verticalSpace,
                        ElevatedButton.icon(
                          onPressed: () => ref.read(expenseListProvider.notifier).refresh(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCEF175),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: Text(
                            'Retry',
                            style: TextStyle(fontSize: 13.spMin, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    final activeCategories = AppConstants.categories.where((cat) {
      return (categoryTotals[cat] ?? 0) > 0;
    }).toList();

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
                AppUtils.formatCurrency(totalKobo),
                style: TextStyle(
                  fontSize: 14.spMin,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Horizontal Segmented Bar (matching reference screenshot)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 22.h,
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

          // Legend chips with percentages (flat and compact)
          Wrap(
            spacing: 14.w,
            runSpacing: 6.h,
            children: AppConstants.categories.map((category) {
              final amount = categoryTotals[category] ?? 0;
              final pct = totalKobo > 0 ? (amount / totalKobo) * 100 : 0.0;
              final color = AppConstants.categoryChartColors[category] ?? const Color(0xFF4EA5F5);

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
                      category,
                      style: TextStyle(
                        fontSize: 14.spMin,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      '$count ${count == 1 ? "expense" : "expenses"}',
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
                    AppUtils.formatCurrency(amountKobo),
                    style: TextStyle(
                      fontSize: 14.spMin,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  2.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: chartColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10.spMin,
                        fontWeight: FontWeight.w700,
                        color: chartColor,
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
              value: (percentage / 100).clamp(0.0, 1.0),
              minHeight: 4.h,
              backgroundColor: const Color(0xFFF2F2F4),
              valueColor: AlwaysStoppedAnimation<Color>(chartColor),
            ),
          ),
        ],
      ),
    );
  }
}
