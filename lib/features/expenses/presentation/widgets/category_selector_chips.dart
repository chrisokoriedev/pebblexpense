import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/utils/utils.dart';

class CategorySelectorChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelectorChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 13.spMin,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
        10.verticalSpace,
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: AppConstants.categories.map((category) {
            final isSelected = selectedCategory == category;
            final emoji = AppUtils.getCategoryEmoji(category);
            final accentColor = AppUtils.getCategoryAccentColor(category);

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: TextStyle(fontSize: 16.spMin)),
                  6.horizontalSpace,
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 13.spMin,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              selectedColor: accentColor,
              backgroundColor: const Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.containerRadius,
                ),
              ),
              side: BorderSide.none,
              showCheckmark: false,
              onSelected: (selected) {
                if (selected) {
                  onCategorySelected(category);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
