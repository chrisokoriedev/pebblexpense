import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClear;

  const TransactionSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFF2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(fontSize: 13.spMin, color: Colors.black),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search by title...',
          hintStyle: TextStyle(fontSize: 13.spMin, color: Colors.black38),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.black45,
            size: 20.spMin,
          ),
          suffixIcon:
              showClear
                  ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.black45,
                      size: 18.spMin,
                    ),
                    onPressed: onClear,
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
        ),
      ),
    );
  }
}
