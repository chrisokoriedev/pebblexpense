import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InsightMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const InsightMetricCard({
    super.key,
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
