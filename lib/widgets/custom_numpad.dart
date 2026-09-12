import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';

class CustomNumpad extends StatelessWidget {
  final Function(String) onTap;

  const CustomNumpad({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      child: Column(
        children: [
          NumpadRow(keys: const ['1', '2', '3'], onTap: onTap),
          16.verticalSpace,
          NumpadRow(keys: const ['4', '5', '6'], onTap: onTap),
          16.verticalSpace,
          NumpadRow(keys: const ['7', '8', '9'], onTap: onTap),
          16.verticalSpace,
          NumpadRow(keys: const ['.', '0', 'backspace'], onTap: onTap),
        ],
      ),
    );
  }
}

class NumpadRow extends StatelessWidget {
  final List<String> keys;
  final Function(String) onTap;

  const NumpadRow({super.key, required this.keys, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((k) {
        return NumpadKey(keyString: k, onTap: onTap);
      }).toList(),
    );
  }
}

class NumpadKey extends StatelessWidget {
  final String keyString;
  final Function(String) onTap;

  const NumpadKey({super.key, required this.keyString, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(keyString),
      child: Container(
        width: 80.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(AppConstants.containerRadius),
        ),
        alignment: Alignment.center,
        child: keyString == 'backspace'
            ? Icon(Icons.backspace_outlined, size: 24.spMin, color: Colors.black87)
            : Text(
                keyString,
                style: TextStyle(
                  fontSize: 24.spMin,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
      ),
    );
  }
}
