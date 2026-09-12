import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
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
  String _selectedCategory = AppConstants.defaultCategory;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onNumpadTap(String value) {
    if (_amountStr.length > 10) return; // Prevent extremely large numbers
    
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
          // ensure only 2 decimal places max
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

      await ref.read(expenseListProvider.notifier).addExpense(
            title: title,
            amountKobo: amountKobo,
            category: _selectedCategory,
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.expenseAdded)),
        );
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    20.verticalSpace,
                    // Title Input
                    Padding(
                      padding: AppPadding.inputSymmetric,
                      child: TextField(
                        controller: _titleController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: AppStrings.expenseTitle,
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 20.spMin, color: Colors.black38),
                        ),
                        style: TextStyle(fontSize: 20.spMin, fontWeight: FontWeight.bold),
                      ),
                    ),
                    
                    // Amount Display
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Text(
                        '₦$_amountStr',
                        style: TextStyle(
                          fontSize: 56.spMin,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    
                    Text(
                      AppStrings.enterAmount,
                      style: TextStyle(color: Colors.black54, fontSize: 16.spMin),
                    ),
                    24.verticalSpace,
                    
                    // Category selector
                    Container(
                      padding: AppPadding.smallSymmetric,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(AppConstants.containerRadius),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          icon: Icon(Icons.keyboard_arrow_down, size: 16.w),
                          items: AppConstants.categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    32.verticalSpace,
                    
                    // Quick chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: AppPadding.pageHorizontal,
                      child: Row(
                        children: AppConstants.quickAmounts.map((amount) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: ActionChip(
                              label: Text('₦$amount'),
                              backgroundColor: const Color(0xFFF9F9F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppConstants.containerRadius),
                              ),
                              side: BorderSide.none,
                              onPressed: () => _addQuickAmount(amount),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Numpad
            CustomNumpad(onTap: _onNumpadTap),
            
            // Submit Button
            Padding(
              padding: AppPadding.pageAll,
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(AppStrings.saveExpense, style: TextStyle(fontSize: 18.spMin)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
