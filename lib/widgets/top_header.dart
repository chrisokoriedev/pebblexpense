import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: AppConstants.avatarRadius,
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black, size: 24.spMin),
              onPressed: () {},
            ),
          ),
          Text(
            AppStrings.myAccount,
            style: TextStyle(
              fontSize: 18.spMin,
              fontWeight: FontWeight.w600,
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: AppConstants.avatarRadius,
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.black, size: 24.spMin),
                  onPressed: () {},
                ),
              ),
              Positioned(
                right: 4.w,
                top: 4.h,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFCEF175), // Lime green
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '2',
                    style: TextStyle(fontSize: 10.spMin, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
