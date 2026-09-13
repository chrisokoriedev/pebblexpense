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
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Home Tab
            _NavBarButton(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => onTabSelected(0),
            ),

            // Center Floating Add Button
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCEF175), // Vibrant Lime
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCEF175).withValues(alpha: 0.5),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 30.spMin,
                ),
              ),
            ),

            // Stats Tab
            _NavBarButton(
              icon: Icons.insights_rounded,
              label: 'Stats',
              isActive: currentIndex == 1,
              onTap: () => onTabSelected(1),
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.black38,
              size: 26.spMin,
            ),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 12.spMin,
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
