import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/core/utils/utils.dart';

class AmountDisplay extends StatelessWidget {
  final String amountStr;
  final VoidCallback? onTap;

  const AmountDisplay({
    super.key,
    required this.amountStr,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedAmount = AppUtils.formatInputAmount(amountStr);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            '₦$formattedAmount',
            style: TextStyle(
              fontSize: 50.spMin,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              color: Colors.black,
            ),
          ),
          4.verticalSpace,
          Text(
            AppStrings.enterAmount,
            style: TextStyle(
              color: Colors.black45,
              fontSize: 14.spMin,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
