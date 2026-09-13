// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_expense_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateExpenseDto _$CreateExpenseDtoFromJson(Map<String, dynamic> json) =>
    _CreateExpenseDto(
      title: json['title'] as String,
      amountKobo: (json['amountKobo'] as num).toInt(),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$CreateExpenseDtoToJson(_CreateExpenseDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'amountKobo': instance.amountKobo,
      'category': instance.category,
    };
