import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/features/insights/presentation/controllers/weekly_insights_controller.dart';
import 'package:pebblexpense/features/insights/presentation/widgets/dashed_line_painter.dart';

class WeeklyBarChartCard extends StatelessWidget {
  final WeeklyInsightsData insights;

  const WeeklyBarChartCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFCEF175),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  'Daily Average: ${AppUtils.formatCurrency(insights.avgDailyKobo)}',
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
                  bottom: 24.h + (120.h * insights.avgRatio),
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
                          painter: DashedLinePainter(color: Colors.black26),
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
                      final amount = insights.dayTotalsKobo[index];
                      final barRatio = insights.maxDayKobo > 0
                          ? (amount / insights.effectiveMax).clamp(0.0, 1.0)
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
                              height: (124.h * barRatio).clamp(barRatio > 0 ? 8.h : 0.0, 124.h),
                              decoration: BoxDecoration(
                                color: barRatio > 0 ? const Color(0xFF2C2C2E) : Colors.transparent,
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
                              color: barRatio > 0 ? Colors.black87 : Colors.black38,
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
