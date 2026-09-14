import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils/utils.dart';

class QuickAmountSelector extends StatelessWidget {
  final ValueChanged<int> onAmountSelected;

  const QuickAmountSelector({
    super.key,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.center,
      children: AppConstants.quickAmounts.map((amount) {
        final formattedQuick = AppUtils.formatInputAmount(amount.toString());
        return ActionChip(
          label: Text(
            '+₦$formattedQuick',
            style: TextStyle(
              fontSize: 13.spMin,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          backgroundColor: const Color(0xFFF5F5F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.containerRadius),
          ),
          side: BorderSide.none,
          onPressed: () => onAmountSelected(amount),
        );
      }).toList(),
    );
  }
}
