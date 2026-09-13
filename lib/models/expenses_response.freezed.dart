// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expenses_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpensesResponse {

 List<Expense> get expenses;
/// Create a copy of ExpensesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpensesResponseCopyWith<ExpensesResponse> get copyWith => _$ExpensesResponseCopyWithImpl<ExpensesResponse>(this as ExpensesResponse, _$identity);

  /// Serializes this ExpensesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExpensesResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpensesResponse&&const DeepCollectionEquality().equals(other.expenses, _this.expenses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExpensesResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.expenses));
}

@override
String toString() {
  final _this = this as ExpensesResponse;
  return 'ExpensesResponse(expenses: ${_this.expenses})';
}


}

/// @nodoc
abstract mixin class $ExpensesResponseCopyWith<$Res>  {
  factory $ExpensesResponseCopyWith(ExpensesResponse value, $Res Function(ExpensesResponse) _then) = _$ExpensesResponseCopyWithImpl;
@useResult
$Res call({
 List<Expense> expenses
});




}
/// @nodoc
class _$ExpensesResponseCopyWithImpl<$Res>
    implements $ExpensesResponseCopyWith<$Res> {
  _$ExpensesResponseCopyWithImpl(this._self, this._then);

  final ExpensesResponse _self;
  final $Res Function(ExpensesResponse) _then;

/// Create a copy of ExpensesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expenses = null,}) {
  return _then(ExpensesResponse(
expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpensesResponse].
extension ExpensesResponsePatterns on ExpensesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpensesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpensesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpensesResponse value)  $default,){
final _that = this;
switch (_that) {
case _ExpensesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpensesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ExpensesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Expense> expenses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpensesResponse() when $default != null:
return $default(_that.expenses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Expense> expenses)  $default,) {final _that = this;
switch (_that) {
case _ExpensesResponse():
return $default(_that.expenses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Expense> expenses)?  $default,) {final _that = this;
switch (_that) {
case _ExpensesResponse() when $default != null:
return $default(_that.expenses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpensesResponse implements ExpensesResponse {
  const _ExpensesResponse({ List<Expense> expenses = const <Expense>[]}): _expenses = expenses;
  factory _ExpensesResponse.fromJson(Map<String, dynamic> json) => _$ExpensesResponseFromJson(json);

 final  List<Expense> _expenses;
@override@JsonKey() List<Expense> get expenses {
  if (_expenses is EqualUnmodifiableListView) return _expenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_expenses);
}


/// Create a copy of ExpensesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpensesResponseCopyWith<_ExpensesResponse> get copyWith => __$ExpensesResponseCopyWithImpl<_ExpensesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpensesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpensesResponse&&const DeepCollectionEquality().equals(other.expenses, _expenses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_expenses));
}

@override
String toString() {
    return 'ExpensesResponse(expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class _$ExpensesResponseCopyWith<$Res> implements $ExpensesResponseCopyWith<$Res> {
  factory _$ExpensesResponseCopyWith(_ExpensesResponse value, $Res Function(_ExpensesResponse) _then) = __$ExpensesResponseCopyWithImpl;
@override @useResult
$Res call({
 List<Expense> expenses
});




}
/// @nodoc
class __$ExpensesResponseCopyWithImpl<$Res>
    implements _$ExpensesResponseCopyWith<$Res> {
  __$ExpensesResponseCopyWithImpl(this._self, this._then);

  final _ExpensesResponse _self;
  final $Res Function(_ExpensesResponse) _then;

/// Create a copy of ExpensesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expenses = null,}) {
  return _then(_ExpensesResponse(
expenses: null == expenses ? _self._expenses : expenses // ignore: cast_nullable_to_non_nullable
as List<Expense>,
  ));
}


}

// dart format on
