import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

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
                          Icon(
                            Icons.bar_chart_rounded,
                            size: 48.spMin,
                            color: Colors.black26,
                          ),
                          12.verticalSpace,
                          Text(
                            'No expense data available yet.\nAdd some expenses to view weekly insights!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.spMin,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending Insights',
                      style: TextStyle(
                        fontSize: 22.spMin,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    3.verticalSpace,
                    Text(
                      'Weekly activity and spending velocity',
                      style: TextStyle(
                        fontSize: 12.spMin,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    16.verticalSpace,

                    // Weekly Bar Chart Card (inspired by reference UI)
                    _WeeklyBarChartCard(expenses: expenses),

                    16.verticalSpace,

                    // Summary Metric Cards
                    _InsightsMetricGrid(expenses: expenses),
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
                          'Unable to Load Insights',
                          style: TextStyle(
                            fontSize: 16.spMin,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        6.verticalSpace,
                        Text(
                          'Check your backend connection and try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.spMin,
                            color: Colors.black54,
                          ),
                        ),
                        16.verticalSpace,
                        ElevatedButton.icon(
                          onPressed: () =>
                              ref.read(expenseListProvider.notifier).refresh(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCEF175),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 13.spMin,
                              fontWeight: FontWeight.w800,
                            ),
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

class _WeeklyBarChartCard extends StatelessWidget {
  final List<Expense> expenses;

  const _WeeklyBarChartCard({required this.expenses});

  @override
  Widget build(BuildContext context) {
    final List<int> dayTotalsKobo = List.filled(7, 0);
    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    for (final exp in expenses) {
      final dayIndex = exp.createdAt.toLocal().weekday % 7;
      dayTotalsKobo[dayIndex] += exp.amountKobo;
    }

    final maxDayKobo = dayTotalsKobo.reduce(max);
    final effectiveMax = maxDayKobo > 0 ? maxDayKobo : 1;
    final totalWeekKobo = dayTotalsKobo.reduce((a, b) => a + b);
    final avgDailyKobo = (totalWeekKobo / 7).round();
    final avgRatio = (avgDailyKobo / effectiveMax).clamp(0.05, 0.95);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
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
                'Weekly Activity',
                style: TextStyle(
                  fontSize: 15.spMin,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              // Flat, compact green/black pill matching FAB
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFCEF175),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  'Daily Average: ${AppUtils.formatCurrency(avgDailyKobo)}',
                  style: TextStyle(
                    fontSize: 11.spMin,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          20.verticalSpace,

          // Bar Chart with Dashed Average Guideline
          SizedBox(
            height: 160.h,
            child: Stack(
              children: [
                // Dashed Guideline
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24.h + (120.h * avgRatio),
                  child: Row(
                    children: [
                      Text(
                        'avg',
                        style: TextStyle(
                          fontSize: 9.spMin,
                          color: Colors.black38,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      6.horizontalSpace,
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedLinePainter(color: Colors.black26),
                          size: Size(double.infinity, 1.h),
                        ),
                      ),
                    ],
                  ),
                ),

                // 7 Vertical Bars
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final amount = dayTotalsKobo[index];
                      final barRatio = maxDayKobo > 0
                          ? (amount / effectiveMax).clamp(0.0, 1.0)
                          : 0.0;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 28.w,
                            height: 124.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F4),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              width: 28.w,
                              height: (124.h * barRatio).clamp(
                                barRatio > 0 ? 8.h : 0.0,
                                124.h,
                              ),
                              decoration: BoxDecoration(
                                color: barRatio > 0
                                    ? const Color(0xFF2C2C2E)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            dayLabels[index],
                            style: TextStyle(
                              fontSize: 11.spMin,
                              fontWeight: FontWeight.w700,
                              color: barRatio > 0
                                  ? Colors.black87
                                  : Colors.black38,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InsightsMetricGrid extends StatelessWidget {
  final List<Expense> expenses;

  const _InsightsMetricGrid({required this.expenses});

  @override
  Widget build(BuildContext context) {
    final totalKobo = expenses.fold<int>(0, (sum, e) => sum + e.amountKobo);
    final avgKobo = (totalKobo / expenses.length).round();
    final maxExpense = expenses.reduce(
      (a, b) => a.amountKobo > b.amountKobo ? a : b,
    );

    final Map<int, int> dayTotals = {};
    for (final exp in expenses) {
      final day = exp.createdAt.toLocal().weekday % 7;
      dayTotals[day] = (dayTotals[day] ?? 0) + exp.amountKobo;
    }
    const dayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    int peakDayIndex = 0;
    int peakDayTotal = -1;
    dayTotals.forEach((day, total) {
      if (total > peakDayTotal) {
        peakDayTotal = total;
        peakDayIndex = day;
      }
    });

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'Average Expense',
                value: AppUtils.formatCurrency(avgKobo),
                subtitle: 'per item',
                icon: Icons.auto_graph_rounded,
                iconColor: const Color(0xFF1E88E5),
                bgColor: const Color(0xFFE8F1FF),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: _MetricCard(
                title: 'Peak Day',
                value: dayNames[peakDayIndex],
                subtitle: AppUtils.formatCurrency(peakDayTotal),
                icon: Icons.calendar_today_rounded,
                iconColor: const Color(0xFFEE6352),
                bgColor: const Color(0xFFFFECEB),
              ),
            ),
          ],
        ),
        10.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: 'Largest Spend',
                value: AppUtils.formatCurrency(maxExpense.amountKobo),
                subtitle: maxExpense.title,
                icon: Icons.arrow_upward_rounded,
                iconColor: const Color(0xFFE53935),
                bgColor: const Color(0xFFFFEBEE),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: _MetricCard(
                title: 'Total Tracked',
                value: AppUtils.formatCurrency(totalKobo),
                subtitle: '${expenses.length} transactions',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: const Color(0xFF43A047),
                bgColor: const Color(0xFFE8F5E9),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
            backgroundColor: bgColor,
            child: Icon(icon, color: iconColor, size: 16.spMin),
          ),
          10.verticalSpace,
          Text(
            title,
            style: TextStyle(
              fontSize: 11.spMin,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
          3.verticalSpace,
          Text(
            value,
            style: TextStyle(
              fontSize: 14.spMin,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          2.verticalSpace,
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.spMin,
              color: Colors.black38,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
