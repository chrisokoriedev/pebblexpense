import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_expense_dto.freezed.dart';
part 'create_expense_dto.g.dart';

@freezed
abstract class CreateExpenseDto with _$CreateExpenseDto {
  const factory CreateExpenseDto({
    required String title,
    required int amountKobo,
    String? category,
  }) = _CreateExpenseDto;

  factory CreateExpenseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateExpenseDtoFromJson(json);
}
