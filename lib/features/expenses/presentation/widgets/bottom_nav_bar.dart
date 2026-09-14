import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';

class PulseBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddTap;

  const PulseBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.bottomNavRadius),
          topRight: Radius.circular(AppConstants.bottomNavRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // 1. Home Tab (index 0)
            _NavBarButton(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => onTabSelected(0),
            ),

            // 2. Insights Tab (index 1)
            _NavBarButton(
              icon: Icons.bar_chart_rounded,
              label: 'Insights',
              isActive: currentIndex == 1,
              onTap: () => onTabSelected(1),
            ),

            // 3. Center Floating Add Button
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCEF175), // Vibrant Lime
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCEF175).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 26.spMin,
                ),
              ),
            ),

            // 4. Categories Tab (index 2)
            _NavBarButton(
              icon: Icons.pie_chart_outline_rounded,
              label: 'Categories',
              isActive: currentIndex == 2,
              onTap: () => onTabSelected(2),
            ),

            // 5. Transactions Tab (index 3)
            _NavBarButton(
              icon: Icons.receipt_long_rounded,
              label: 'Expenses',
              isActive: currentIndex == 3,
              onTap: () => onTabSelected(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.black38,
              size: 22.spMin,
            ),
            3.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 10.spMin,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.black : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
