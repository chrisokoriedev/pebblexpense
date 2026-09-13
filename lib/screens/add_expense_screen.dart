import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/core/utils.dart';
import 'package:pebblexpense/providers/expense_provider.dart';
import 'package:pebblexpense/widgets/custom_numpad.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  String _amountStr = '0';
  final _titleController = TextEditingController();
  final _titleFocusNode = FocusNode();
  String _selectedCategory = AppConstants.defaultCategory;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _onNumpadTap(String value) {
    if (_amountStr.length > 10) return; // Prevent overflow

    setState(() {
      if (value == 'backspace') {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = '0';
        }
      } else if (value == '.') {
        if (!_amountStr.contains('.')) {
          _amountStr += '.';
        }
      } else {
        if (_amountStr == '0') {
          _amountStr = value;
        } else {
          // Max 2 decimal places
          if (_amountStr.contains('.')) {
            final parts = _amountStr.split('.');
            if (parts.length > 1 && parts[1].length >= 2) {
              return;
            }
          }
          _amountStr += value;
        }
      }
    });
  }

  void _addQuickAmount(int amount) {
    setState(() {
      _amountStr = amount.toString();
    });
  }

  void _submit() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      _titleFocusNode.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.pleaseEnterTitle)),
      );
      return;
    }

    final amountNgn = double.tryParse(_amountStr) ?? 0.0;
    if (amountNgn <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.pleaseEnterValidAmount)),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final amountKobo = (amountNgn * 100).round();

      await ref
          .read(expenseListProvider.notifier)
          .addExpense(
            title: title,
            amountKobo: amountKobo,
            category: _selectedCategory,
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.expenseAdded)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.failedToAddExpense}$e')),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditingTitle = _titleFocusNode.hasFocus;
    final formattedAmountWithCommas = AppUtils.formatInputAmount(_amountStr);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'New Expense',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.spMin,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    16.verticalSpace,

                    // Title Input with suffix check icon
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: isEditingTitle
                            ? const Color(0xFFF9F9F9)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (isEditingTitle) SizedBox(width: 36.w),
                              Expanded(
                                child: TextField(
                                  controller: _titleController,
                                  focusNode: _titleFocusNode,
                                  textAlign: TextAlign.center,
                                  cursorColor: const Color(
                                    0xFFE53935,
                                  ), // Red/coral cursor
                                  cursorWidth: 2.5,
                                  cursorRadius: const Radius.circular(2),
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _titleFocusNode.unfocus(),
                                  decoration: InputDecoration(
                                    hintText: 'What did you spend on?',
                                    hintStyle: TextStyle(
                                      fontSize: 18.spMin,
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 20.spMin,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (isEditingTitle)
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(
                                    minWidth: 36.w,
                                    minHeight: 36.h,
                                  ),
                                  icon: Container(
                                    padding: EdgeInsets.all(5.w),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFCEF175), // Vibrant Lime
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.black,
                                      size: 16.spMin,
                                    ),
                                  ),
                                  onPressed: () => _titleFocusNode.unfocus(),
                                  tooltip: 'Done',
                                ),
                            ],
                          ),
                          // Highlight indicator / red underscore
                          Container(
                            height: 2.5.h,
                            width: 140.w,
                            decoration: BoxDecoration(
                              color: isEditingTitle
                                  ? const Color(
                                      0xFFE53935,
                                    ) // Active red underscore
                                  : Colors.black12,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ],
                      ),
                    ),

                    20.verticalSpace,

                    // Amount Display with Thousands Commas
                    GestureDetector(
                      onTap: () {
                        // Dismiss title keyboard to focus on numpad
                        if (_titleFocusNode.hasFocus) {
                          _titleFocusNode.unfocus();
                        }
                      },
                      child: Column(
                        children: [
                          Text(
                            '₦$formattedAmountWithCommas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50.spMin,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.5,
                              color: Colors.black,
                            ),
                          ),
                          4.verticalSpace,
                          Text(
                            AppStrings.enterAmount,
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14.spMin,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    24.verticalSpace,

                    // Category Selector with Obvious Emojis
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 13.spMin,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    // Category Selector with Obvious Emojis (using Wrap)
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: AppConstants.categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        final emoji = AppUtils.getCategoryEmoji(category);
                        final accentColor = AppUtils.getCategoryAccentColor(
                          category,
                        );

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
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
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
                              setState(() {
                                _selectedCategory = category;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),

                    20.verticalSpace,

                    // Quick amounts with Wrap
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      alignment: WrapAlignment.center,
                      children: AppConstants.quickAmounts.map((amount) {
                        final formattedQuick = AppUtils.formatInputAmount(
                          amount.toString(),
                        );
                        return ActionChip(
                          label: Text(
                            '+₦$formattedQuick',
                            style: TextStyle(
                              fontSize: 13.spMin,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          backgroundColor: const Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.containerRadius,
                            ),
                          ),
                          side: BorderSide.none,
                          onPressed: () => _addQuickAmount(amount),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Position: Numpad is shown when not editing title
            if (!isEditingTitle) CustomNumpad(onTap: _onNumpadTap),

            // Submit Button
            Padding(
              padding: AppPadding.pageAll,
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.buttonRadius,
                      ),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          AppStrings.saveExpense,
                          style: TextStyle(
                            fontSize: 16.spMin,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
