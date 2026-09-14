import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseTitleInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEditing;

  const ExpenseTitleInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isEditing ? const Color(0xFFF9F9F9) : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (isEditing) SizedBox(width: 36.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.center,
                  cursorColor: const Color(0xFFE53935),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => focusNode.unfocus(),
                  decoration: InputDecoration(
                    hintText: 'What did you spend on?',
                    hintStyle: TextStyle(
                      fontSize: 18.spMin,
                      color: Colors.black38,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 20.spMin,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isEditing)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
                  icon: Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFCEF175),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.black,
                      size: 16.spMin,
                    ),
                  ),
                  onPressed: () => focusNode.unfocus(),
                ),
            ],
          ),
          Container(
            height: 2.5.h,
            width: 140.w,
            decoration: BoxDecoration(
              color: isEditing ? const Color(0xFFE53935) : Colors.black12,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }
}
