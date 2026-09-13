import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pebblexpense/models/expense.dart';

part 'expenses_response.freezed.dart';
part 'expenses_response.g.dart';

@freezed
abstract class ExpensesResponse with _$ExpensesResponse {
  const factory ExpensesResponse({
    @Default(<Expense>[]) List<Expense> expenses,
  }) = _ExpensesResponse;

  factory ExpensesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExpensesResponseFromJson(json);
}
