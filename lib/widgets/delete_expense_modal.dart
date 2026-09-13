import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';

class DeleteExpenseModal extends StatelessWidget {
  const DeleteExpenseModal({super.key});

  /// Static helper to display the styled delete confirmation modal sheet
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const DeleteExpenseModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 36.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.cardRadius),
          topRight: Radius.circular(AppConstants.cardRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Red Trash Icon
          Container(
            width: 56.w,
            height: 56.h,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: const Color(0xFFE53935),
              size: 28.spMin,
            ),
          ),
          16.verticalSpace,

          // Title
          Text(
            'Delete Expense?',
            style: TextStyle(
              fontSize: 20.spMin,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          8.verticalSpace,

          // Description
          Text(
            'This action cannot be undone. Are you sure you want to permanently delete this expense?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.spMin,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
          24.verticalSpace,

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                      ),
                    ),
                    onPressed: () => context.pop(false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15.spMin,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: SizedBox(
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                      ),
                    ),
                    onPressed: () => context.pop(true),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 15.spMin,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
