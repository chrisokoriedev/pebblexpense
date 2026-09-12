import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';

class ActionRow extends StatelessWidget {
  const ActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            icon: Icons.arrow_outward,
            label: AppStrings.addExpense,
            isPrimary: true,
            onTap: () => context.push('/add'),
          ),
          ActionButton(
            icon: Icons.south_west,
            label: AppStrings.request,
            onTap: () {},
          ),
          ActionButton(
            icon: Icons.swap_horiz,
            label: AppStrings.exchange,
            onTap: () {},
          ),
          ActionButton(
            icon: Icons.more_horiz,
            label: AppStrings.more,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary ? const Color(0xFFCEF175) : Colors.white;
    
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: AppConstants.actionAvatarRadius,
            backgroundColor: bgColor,
            child: Icon(icon, color: Colors.black, size: 24.spMin),
          ),
        ),
        8.verticalSpace,
        Text(
          label,
          style: TextStyle(
            fontSize: 12.spMin,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
