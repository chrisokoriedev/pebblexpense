import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pebblexpense/core/constants/app_constants.dart';
import 'package:pebblexpense/features/expenses/controller/expense_list_controller.dart';

class CategoryBreakdownItem {
  final String category;
  final int amountKobo;
  final int count;
  final double percentage;
  final Color chartColor;

  const CategoryBreakdownItem({
    required this.category,
    required this.amountKobo,
    required this.count,
    required this.percentage,
    required this.chartColor,
  });
}

class CategoryAnalysisData {
  final int totalKobo;
  final Map<String, int> categoryTotals;
  final Map<String, int> categoryCounts;
  final List<String> activeCategories;
  final List<CategoryBreakdownItem> breakdownItems;

  const CategoryAnalysisData({
    required this.totalKobo,
    required this.categoryTotals,
    required this.categoryCounts,
    required this.activeCategories,
    required this.breakdownItems,
  });
}

final categoryAnalysisProvider = Provider<CategoryAnalysisData?>((ref) {
  final expensesState = ref.watch(expenseListProvider);
  final expenses = expensesState.value;

  if (expenses == null || expenses.isEmpty) {
    return null;
  }

  final totalKobo = expenses.fold<int>(0, (sum, e) => sum + e.amountKobo);

  final Map<String, int> categoryTotals = {};
  final Map<String, int> categoryCounts = {};
  for (final cat in AppConstants.categories) {
    categoryTotals[cat] = 0;
    categoryCounts[cat] = 0;
  }

  for (final exp in expenses) {
    final cat = exp.category ?? 'Other';
    categoryTotals[cat] = (categoryTotals[cat] ?? 0) + exp.amountKobo;
    categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
  }

  final activeCategories = AppConstants.categories.where((cat) {
    return (categoryTotals[cat] ?? 0) > 0;
  }).toList();

  final breakdownItems = AppConstants.categories.map((category) {
    final amountKobo = categoryTotals[category] ?? 0;
    final count = categoryCounts[category] ?? 0;
    final percentage = totalKobo > 0 ? (amountKobo / totalKobo) * 100 : 0.0;
    final chartColor =
        AppConstants.categoryChartColors[category] ?? const Color(0xFF4EA5F5);

    return CategoryBreakdownItem(
      category: category,
      amountKobo: amountKobo,
      count: count,
      percentage: percentage,
      chartColor: chartColor,
    );
  }).toList();

  return CategoryAnalysisData(
    totalKobo: totalKobo,
    categoryTotals: categoryTotals,
    categoryCounts: categoryCounts,
    activeCategories: activeCategories,
    breakdownItems: breakdownItems,
  );
});
