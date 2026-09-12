import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';

class MockBottomNavBar extends StatelessWidget {
  const MockBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.bottomNavRadius),
          topRight: Radius.circular(AppConstants.bottomNavRadius),
        ),
      ),
      padding: AppPadding.bottomNavVertical,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            BottomNavItem(icon: Icons.home_outlined, label: AppStrings.home, isActive: true),
            BottomNavItem(icon: Icons.insert_chart_outlined, label: AppStrings.statistic),
            BottomNavItem(icon: Icons.crop_free, label: AppStrings.scan, isCenter: true),
            BottomNavItem(icon: Icons.credit_card_outlined, label: AppStrings.card),
            BottomNavItem(icon: Icons.person_outline, label: AppStrings.profile),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCenter;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCenter) {
      return CircleAvatar(
        radius: AppConstants.actionAvatarRadius,
        backgroundColor: const Color(0xFFCEF175),
        child: Icon(icon, color: Colors.black, size: 24.spMin),
      );
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.black : Colors.black45, size: 24.spMin),
        4.verticalSpace,
        Text(
          label,
          style: TextStyle(
            fontSize: 10.spMin,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.black : Colors.black45,
          ),
        ),
      ],
    );
  }
}
