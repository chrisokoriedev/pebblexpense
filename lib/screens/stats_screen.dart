import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

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
                  'No expense statistics yet.\nAdd some expenses to see analytics!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              );
            }

            final totalKobo = expenses.fold<int>(0, (sum, e) => sum + e.amountKobo);
            final avgKobo = (totalKobo / expenses.length).round();
            final maxExpense = expenses.reduce((a, b) => a.amountKobo > b.amountKobo ? a : b);

            // Group by category
            final Map<String, int> categoryTotals = {};
            for (final cat in AppConstants.categories) {
              categoryTotals[cat] = 0;
            }
            for (final exp in expenses) {
              final cat = exp.category ?? 'Other';
              categoryTotals[cat] = (categoryTotals[cat] ?? 0) + exp.amountKobo;
            }

            // Top category
            String topCategory = 'Other';
            int topCatAmount = -1;
            categoryTotals.forEach((cat, amount) {
              if (amount > topCatAmount) {
                topCatAmount = amount;
                topCategory = cat;
              }
            });

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spending Insights',
                    style: TextStyle(
                      fontSize: 24.spMin,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'Real-time breakdown of your expense patterns',
                    style: TextStyle(
                      fontSize: 13.spMin,
                      color: Colors.black45,
                    ),
                  ),
                  20.verticalSpace,

                  // Summary Metric Cards
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          title: 'Average Expense',
                          value: AppUtils.formatCurrency(avgKobo),
                          icon: Icons.auto_graph_rounded,
                          color: const Color(0xFF1E88E5),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: _MetricCard(
                          title: 'Largest Expense',
                          value: AppUtils.formatCurrency(maxExpense.amountKobo),
                          icon: Icons.trending_up_rounded,
                          color: const Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,

                  // Spending Flow Wave Chart
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Spending Flow',
                              style: TextStyle(
                                fontSize: 16.spMin,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCEF175),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                'Top: ${AppUtils.getCategoryEmoji(topCategory)} $topCategory',
                                style: TextStyle(
                                  fontSize: 11.spMin,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        20.verticalSpace,
                        SizedBox(
                          height: 150.h,
                          child: _SpendingFlowChart(expenses: expenses),
                        ),
                      ],
                    ),
                  ),
                  24.verticalSpace,

                  // Category Breakdown with Emojis
                  Text(
                    'Category Distribution',
                    style: TextStyle(
                      fontSize: 18.spMin,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  12.verticalSpace,

                  ...AppConstants.categories.map((category) {
                    final catTotal = categoryTotals[category] ?? 0;
                    final percentage = totalKobo > 0 ? (catTotal / totalKobo) : 0.0;
                    final emoji = AppUtils.getCategoryEmoji(category);
                    final accentColor = AppUtils.getCategoryAccentColor(category);

                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: AppUtils.getAvatarColor(category),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Center(
                                        child: Text(emoji, style: TextStyle(fontSize: 20.spMin)),
                                      ),
                                    ),
                                    12.horizontalSpace,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 15.spMin,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '${(percentage * 100).toStringAsFixed(1)}% of total',
                                          style: TextStyle(
                                            fontSize: 12.spMin,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  AppUtils.formatCurrency(catTotal),
                                  style: TextStyle(
                                    fontSize: 15.spMin,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            12.verticalSpace,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                value: percentage,
                                minHeight: 6.h,
                                backgroundColor: const Color(0xFFF0F0F0),
                                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error loading stats: $e')),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.containerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 18.spMin),
          ),
          12.verticalSpace,
          Text(
            title,
            style: TextStyle(
              fontSize: 12.spMin,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          4.verticalSpace,
          Text(
            value,
            style: TextStyle(
              fontSize: 16.spMin,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpendingFlowChart extends StatelessWidget {
  final List<Expense> expenses;

  const _SpendingFlowChart({required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Generate daily totals for the last 7 days
    final now = DateTime.now();
    final List<MapEntry<String, double>> dailyData = [];

    for (int i = 6; i >= 0; i--) {
      final targetDate = now.subtract(Duration(days: i));
      final dayKey = DateFormat('E').format(targetDate); // Mon, Tue...

      final dayTotalKobo = expenses
          .where((e) =>
              e.createdAt.year == targetDate.year &&
              e.createdAt.month == targetDate.month &&
              e.createdAt.day == targetDate.day)
          .fold<int>(0, (sum, e) => sum + e.amountKobo);

      dailyData.add(MapEntry(dayKey, dayTotalKobo / 100)); // in Naira
    }

    final maxVal = dailyData.map((e) => e.value).reduce(max);
    final effectiveMax = maxVal == 0 ? 100.0 : maxVal;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: dailyData.map((entry) {
        final ratio = (entry.value / effectiveMax).clamp(0.08, 1.0);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (entry.value > 0)
                  Text(
                    '₦${(entry.value / 1000).toStringAsFixed(0)}k',
                    style: TextStyle(
                      fontSize: 9.spMin,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                4.verticalSpace,
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 100.h * ratio,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFFCEF175),
                        entry.value > 0 ? const Color(0xFF90CA32) : const Color(0xFFE0E0E0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                8.verticalSpace,
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
