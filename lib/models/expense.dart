import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const Expense._(); // Added constructor to allow custom methods

  const factory Expense({
    required String id,
    required String title,
    required int amountKobo,
    required String category,
    required DateTime createdAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  // Helper method to display amount in NGN formatted string
  String get formattedAmount {
    final naira = amountKobo / 100;
    // We will use intl package in UI to format, but having a simple accessor is nice.
    return naira.toStringAsFixed(2);
  }
}
