import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/features/insights/presentation/controllers/weekly_insights_controller.dart';
import 'package:pebblexpense/features/insights/presentation/widgets/insights_metric_grid.dart';
import 'package:pebblexpense/features/insights/presentation/widgets/weekly_bar_chart_card.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListProvider);
    final insights = ref.watch(weeklyInsightsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(expenseListProvider.notifier).refresh(),
          child: expensesAsync.when(
            data: (expenses) {
              if (expenses.isEmpty || insights == null) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 120.h),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart_rounded, size: 48.spMin, color: Colors.black26),
                          12.verticalSpace,
                          Text(
                            'No expense data available yet.\nAdd some expenses to view weekly insights!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13.spMin, color: Colors.black54),
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

                    // Weekly Bar Chart Widget
                    WeeklyBarChartCard(insights: insights),

                    16.verticalSpace,

                    // Metrics Grid Widget
                    InsightsMetricGrid(insights: insights),
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
                          style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w700),
                        ),
                        6.verticalSpace,
                        Text(
                          'Check your backend connection and try again.',
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
