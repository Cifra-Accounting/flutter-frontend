// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTransactionEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CreateTransactionEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CreateTransactionEvent()';
  }
}

/// @nodoc
class $CreateTransactionEventCopyWith<$Res> {
  $CreateTransactionEventCopyWith(
      CreateTransactionEvent _, $Res Function(CreateTransactionEvent) __);
}

/// @nodoc

class Update implements CreateTransactionEvent {
  const Update(
      {this.category, this.amount, this.type, this.title, this.description});

  final Category? category;
  final Money? amount;
  final TransactionType? type;
  final String? title;
  final String? description;

  /// Create a copy of CreateTransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateCopyWith<Update> get copyWith =>
      _$UpdateCopyWithImpl<Update>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Update &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, category, amount, type, title, description);

  @override
  String toString() {
    return 'CreateTransactionEvent.update(category: $category, amount: $amount, type: $type, title: $title, description: $description)';
  }
}

/// @nodoc
abstract mixin class $UpdateCopyWith<$Res>
    implements $CreateTransactionEventCopyWith<$Res> {
  factory $UpdateCopyWith(Update value, $Res Function(Update) _then) =
      _$UpdateCopyWithImpl;
  @useResult
  $Res call(
      {Category? category,
      Money? amount,
      TransactionType? type,
      String? title,
      String? description});
}

/// @nodoc
class _$UpdateCopyWithImpl<$Res> implements $UpdateCopyWith<$Res> {
  _$UpdateCopyWithImpl(this._self, this._then);

  final Update _self;
  final $Res Function(Update) _then;

  /// Create a copy of CreateTransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? category = freezed,
    Object? amount = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? description = freezed,
  }) {
    return _then(Update(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class Submit implements CreateTransactionEvent {
  const Submit();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Submit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CreateTransactionEvent.submit()';
  }
}

/// @nodoc

class ErrorEvent implements CreateTransactionEvent {
  const ErrorEvent({this.e, this.st});

  final Object? e;
  final StackTrace? st;

  /// Create a copy of CreateTransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ErrorEventCopyWith<ErrorEvent> get copyWith =>
      _$ErrorEventCopyWithImpl<ErrorEvent>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ErrorEvent &&
            const DeepCollectionEquality().equals(other.e, e) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(e), st);

  @override
  String toString() {
    return 'CreateTransactionEvent.error(e: $e, st: $st)';
  }
}

/// @nodoc
abstract mixin class $ErrorEventCopyWith<$Res>
    implements $CreateTransactionEventCopyWith<$Res> {
  factory $ErrorEventCopyWith(
          ErrorEvent value, $Res Function(ErrorEvent) _then) =
      _$ErrorEventCopyWithImpl;
  @useResult
  $Res call({Object? e, StackTrace? st});
}

/// @nodoc
class _$ErrorEventCopyWithImpl<$Res> implements $ErrorEventCopyWith<$Res> {
  _$ErrorEventCopyWithImpl(this._self, this._then);

  final ErrorEvent _self;
  final $Res Function(ErrorEvent) _then;

  /// Create a copy of CreateTransactionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? e = freezed,
    Object? st = freezed,
  }) {
    return _then(ErrorEvent(
      e: freezed == e ? _self.e : e,
      st: freezed == st
          ? _self.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class ShouldUpdateCategories implements CreateTransactionEvent {
  const ShouldUpdateCategories();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ShouldUpdateCategories);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CreateTransactionEvent.shouldUpdateCategories()';
  }
}

// dart format on
