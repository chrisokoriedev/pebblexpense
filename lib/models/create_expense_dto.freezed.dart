// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_expense_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateExpenseDto {

 String get title; int get amountKobo; String? get category;
/// Create a copy of CreateExpenseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateExpenseDtoCopyWith<CreateExpenseDto> get copyWith => _$CreateExpenseDtoCopyWithImpl<CreateExpenseDto>(this as CreateExpenseDto, _$identity);

  /// Serializes this CreateExpenseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CreateExpenseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateExpenseDto&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.amountKobo, _this.amountKobo) || other.amountKobo == _this.amountKobo)&&(identical(other.category, _this.category) || other.category == _this.category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CreateExpenseDto;
  return Object.hash(runtimeType,_this.title,_this.amountKobo,_this.category);
}

@override
String toString() {
  final _this = this as CreateExpenseDto;
  return 'CreateExpenseDto(title: ${_this.title}, amountKobo: ${_this.amountKobo}, category: ${_this.category})';
}


}

/// @nodoc
abstract mixin class $CreateExpenseDtoCopyWith<$Res>  {
  factory $CreateExpenseDtoCopyWith(CreateExpenseDto value, $Res Function(CreateExpenseDto) _then) = _$CreateExpenseDtoCopyWithImpl;
@useResult
$Res call({
 String title, int amountKobo, String? category
});




}
/// @nodoc
class _$CreateExpenseDtoCopyWithImpl<$Res>
    implements $CreateExpenseDtoCopyWith<$Res> {
  _$CreateExpenseDtoCopyWithImpl(this._self, this._then);

  final CreateExpenseDto _self;
  final $Res Function(CreateExpenseDto) _then;

/// Create a copy of CreateExpenseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? amountKobo = null,Object? category = freezed,}) {
  return _then(CreateExpenseDto(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateExpenseDto].
extension CreateExpenseDtoPatterns on CreateExpenseDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateExpenseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateExpenseDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateExpenseDto value)  $default,){
final _that = this;
switch (_that) {
case _CreateExpenseDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateExpenseDto value)?  $default,){
final _that = this;
switch (_that) {
case _CreateExpenseDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int amountKobo,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateExpenseDto() when $default != null:
return $default(_that.title,_that.amountKobo,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int amountKobo,  String? category)  $default,) {final _that = this;
switch (_that) {
case _CreateExpenseDto():
return $default(_that.title,_that.amountKobo,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int amountKobo,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _CreateExpenseDto() when $default != null:
return $default(_that.title,_that.amountKobo,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateExpenseDto implements CreateExpenseDto {
  const _CreateExpenseDto({required this.title, required this.amountKobo, this.category});
  factory _CreateExpenseDto.fromJson(Map<String, dynamic> json) => _$CreateExpenseDtoFromJson(json);

@override final  String title;
@override final  int amountKobo;
@override final  String? category;

/// Create a copy of CreateExpenseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateExpenseDtoCopyWith<_CreateExpenseDto> get copyWith => __$CreateExpenseDtoCopyWithImpl<_CreateExpenseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateExpenseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateExpenseDto&&(identical(other.title, title) || other.title == title)&&(identical(other.amountKobo, amountKobo) || other.amountKobo == amountKobo)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,title,amountKobo,category);
}

@override
String toString() {
    return 'CreateExpenseDto(title: $title, amountKobo: $amountKobo, category: $category)';
}


}

/// @nodoc
abstract mixin class _$CreateExpenseDtoCopyWith<$Res> implements $CreateExpenseDtoCopyWith<$Res> {
  factory _$CreateExpenseDtoCopyWith(_CreateExpenseDto value, $Res Function(_CreateExpenseDto) _then) = __$CreateExpenseDtoCopyWithImpl;
@override @useResult
$Res call({
 String title, int amountKobo, String? category
});




}
/// @nodoc
class __$CreateExpenseDtoCopyWithImpl<$Res>
    implements _$CreateExpenseDtoCopyWith<$Res> {
  __$CreateExpenseDtoCopyWithImpl(this._self, this._then);

  final _CreateExpenseDto _self;
  final $Res Function(_CreateExpenseDto) _then;

/// Create a copy of CreateExpenseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? amountKobo = null,Object? category = freezed,}) {
  return _then(_CreateExpenseDto(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amountKobo: null == amountKobo ? _self.amountKobo : amountKobo // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
