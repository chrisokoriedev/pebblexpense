import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/core/constants/app_padding.dart';
import 'package:pebblexpense/core/constants/app_strings.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/amount_display.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/category_selector_chips.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/custom_numpad.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/expense_title_input.dart';
import 'package:pebblexpense/features/expenses/presentation/widgets/quick_amount_selector.dart';

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
    _titleFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _onNumpadTap(String value) {
    if (_amountStr.length > 10) return;
    setState(() {
      if (value == 'backspace') {
        _amountStr = _amountStr.length > 1 ? _amountStr.substring(0, _amountStr.length - 1) : '0';
      } else if (value == '.') {
        if (!_amountStr.contains('.')) _amountStr += '.';
      } else if (_amountStr == '0') {
        _amountStr = value;
      } else if (!_amountStr.contains('.') || _amountStr.split('.').last.length < 2) {
        _amountStr += value;
      }
    });
  }

  void _submit() async {
    final title = _titleController.text.trim();
    final amountNgn = double.tryParse(_amountStr) ?? 0.0;
    if (title.isEmpty) {
      _titleFocusNode.requestFocus();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseEnterTitle)));
      return;
    }
    if (amountNgn <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.pleaseEnterValidAmount)));
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await ref.read(expenseListProvider.notifier).addExpense(
            title: title,
            amountKobo: (amountNgn * 100).round(),
            category: _selectedCategory,
          );
      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.expenseAdded)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppStrings.failedToAddExpense}$e')));
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditingTitle = _titleFocusNode.hasFocus;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close_rounded, color: Colors.black), onPressed: () => context.pop()),
        title: Text('New Expense', style: TextStyle(color: Colors.black, fontSize: 18.spMin, fontWeight: FontWeight.w700)),
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
                    ExpenseTitleInput(controller: _titleController, focusNode: _titleFocusNode, isEditing: isEditingTitle),
                    20.verticalSpace,
                    AmountDisplay(
                      amountStr: _amountStr,
                      onTap: () {
                        if (_titleFocusNode.hasFocus) _titleFocusNode.unfocus();
                      },
                    ),
                    24.verticalSpace,
                    CategorySelectorChips(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (cat) => setState(() => _selectedCategory = cat),
                    ),
                    20.verticalSpace,
                    QuickAmountSelector(
                      onAmountSelected: (amt) => setState(() => _amountStr = amt.toString()),
                    ),
                  ],
                ),
              ),
            ),
            if (!isEditingTitle) CustomNumpad(onTap: _onNumpadTap),
            Padding(
              padding: AppPadding.pageAll,
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
                  ),
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(AppStrings.saveExpense, style: TextStyle(fontSize: 16.spMin, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
