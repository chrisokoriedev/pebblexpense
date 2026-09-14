// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExpensesResponse _$ExpensesResponseFromJson(Map<String, dynamic> json) =>
    _ExpensesResponse(
      expenses:
          (json['expenses'] as List<dynamic>?)
              ?.map((e) => Expense.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Expense>[],
    );

Map<String, dynamic> _$ExpensesResponseToJson(_ExpensesResponse instance) =>
    <String, dynamic>{'expenses': instance.expenses};
