import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pebblexpense/models/expense.dart';
import 'package:pebblexpense/providers/expense_provider.dart';

class WeeklyInsightsData {
  final List<int> dayTotalsKobo;
  final int maxDayKobo;
  final int effectiveMax;
  final int totalWeekKobo;
  final int avgDailyKobo;
  final double avgRatio;
  final String peakDayName;
  final int peakDayTotal;
  final Expense? maxExpense;
  final int totalTrackedKobo;
  final int transactionCount;

  const WeeklyInsightsData({
    required this.dayTotalsKobo,
    required this.maxDayKobo,
    required this.effectiveMax,
    required this.totalWeekKobo,
    required this.avgDailyKobo,
    required this.avgRatio,
    required this.peakDayName,
    required this.peakDayTotal,
    required this.maxExpense,
    required this.totalTrackedKobo,
    required this.transactionCount,
  });
}

final weeklyInsightsProvider = Provider<WeeklyInsightsData?>((ref) {
  final expensesState = ref.watch(expenseListProvider);
  final expenses = expensesState.value;

  if (expenses == null || expenses.isEmpty) {
    return null;
  }

  // 1. Calculate spending for days of the week (Sunday=0 .. Saturday=6)
  final List<int> dayTotals = List.filled(7, 0);
  for (final exp in expenses) {
    final dayIndex = exp.createdAt.toLocal().weekday % 7;
    dayTotals[dayIndex] += exp.amountKobo;
  }

  final maxDay = dayTotals.reduce(max);
  final effectiveMax = maxDay > 0 ? maxDay : 1;
  final totalWeek = dayTotals.reduce((a, b) => a + b);
  final avgDaily = (totalWeek / 7).round();
  final avgRatio = (avgDaily / effectiveMax).clamp(0.05, 0.95);

  // 2. Compute peak day
  const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  int peakDayIndex = 0;
  int peakTotal = -1;
  for (int i = 0; i < 7; i++) {
    if (dayTotals[i] > peakTotal) {
      peakTotal = dayTotals[i];
      peakDayIndex = i;
    }
  }

  // 3. Find largest single expense
  final maxExpense = expenses.reduce((a, b) => a.amountKobo > b.amountKobo ? a : b);
  final totalTracked = expenses.fold<int>(0, (sum, e) => sum + e.amountKobo);

  return WeeklyInsightsData(
    dayTotalsKobo: dayTotals,
    maxDayKobo: maxDay,
    effectiveMax: effectiveMax,
    totalWeekKobo: totalWeek,
    avgDailyKobo: avgDaily,
    avgRatio: avgRatio,
    peakDayName: dayNames[peakDayIndex],
    peakDayTotal: peakTotal,
    maxExpense: maxExpense,
    totalTrackedKobo: totalTracked,
    transactionCount: expenses.length,
  );
});
