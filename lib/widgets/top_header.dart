import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final todayFormatted = DateFormat('MMM d, yyyy').format(DateTime.now());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pulse',
                style: TextStyle(
                  fontSize: 24.spMin,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Colors.black,
                ),
              ),
              2.verticalSpace,
              Text(
                'Expense Tracker',
                style: TextStyle(
                  fontSize: 13.spMin,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14.spMin,
                  color: Colors.black87,
                ),
                8.horizontalSpace,
                Text(
                  todayFormatted,
                  style: TextStyle(
                    fontSize: 12.spMin,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
