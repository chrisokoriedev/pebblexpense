import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/features/insights/presentation/controllers/weekly_insights_controller.dart';
import 'package:pebblexpense/features/insights/presentation/widgets/insight_metric_card.dart';

class InsightsMetricGrid extends StatelessWidget {
  final WeeklyInsightsData insights;

  const InsightsMetricGrid({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final maxAmount = insights.maxExpense?.amountKobo ?? 0;
    final maxTitle = insights.maxExpense?.title ?? 'None';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InsightMetricCard(
                title: 'Average Expense',
                value: AppUtils.formatCurrency(insights.avgDailyKobo),
                subtitle: 'daily average',
                icon: Icons.auto_graph_rounded,
                iconColor: const Color(0xFF1E88E5),
                bgColor: const Color(0xFFE8F1FF),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: InsightMetricCard(
                title: 'Peak Day',
                value: insights.peakDayName,
                subtitle: AppUtils.formatCurrency(insights.peakDayTotal),
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
              child: InsightMetricCard(
                title: 'Largest Spend',
                value: AppUtils.formatCurrency(maxAmount),
                subtitle: maxTitle,
                icon: Icons.arrow_upward_rounded,
                iconColor: const Color(0xFFE53935),
                bgColor: const Color(0xFFFFEBEE),
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: InsightMetricCard(
                title: 'Total Tracked',
                value: AppUtils.formatCurrency(insights.totalTrackedKobo),
                subtitle: '${insights.transactionCount} transactions',
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
