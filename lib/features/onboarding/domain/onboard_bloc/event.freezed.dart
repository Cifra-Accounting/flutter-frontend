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
mixin _$IntroEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is IntroEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'IntroEvent()';
  }
}

/// @nodoc
class $IntroEventCopyWith<$Res> {
  $IntroEventCopyWith(IntroEvent _, $Res Function(IntroEvent) __);
}

/// @nodoc

class Update implements IntroEvent {
  Update(
      {this.currency,
      this.amountInSmallestUnits,
      this.language,
      this.dateFormat});

  final Currency? currency;
  final int? amountInSmallestUnits;
  final Languages? language;
  final DateFormat? dateFormat;

  /// Create a copy of IntroEvent
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
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.amountInSmallestUnits, amountInSmallestUnits) ||
                other.amountInSmallestUnits == amountInSmallestUnits) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.dateFormat, dateFormat) ||
                other.dateFormat == dateFormat));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, currency, amountInSmallestUnits, language, dateFormat);

  @override
  String toString() {
    return 'IntroEvent.update(currency: $currency, amountInSmallestUnits: $amountInSmallestUnits, language: $language, dateFormat: $dateFormat)';
  }
}

/// @nodoc
abstract mixin class $UpdateCopyWith<$Res>
    implements $IntroEventCopyWith<$Res> {
  factory $UpdateCopyWith(Update value, $Res Function(Update) _then) =
      _$UpdateCopyWithImpl;
  @useResult
  $Res call(
      {Currency? currency,
      int? amountInSmallestUnits,
      Languages? language,
      DateFormat? dateFormat});
}

/// @nodoc
class _$UpdateCopyWithImpl<$Res> implements $UpdateCopyWith<$Res> {
  _$UpdateCopyWithImpl(this._self, this._then);

  final Update _self;
  final $Res Function(Update) _then;

  /// Create a copy of IntroEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currency = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? language = freezed,
    Object? dateFormat = freezed,
  }) {
    return _then(Update(
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      amountInSmallestUnits: freezed == amountInSmallestUnits
          ? _self.amountInSmallestUnits
          : amountInSmallestUnits // ignore: cast_nullable_to_non_nullable
              as int?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as Languages?,
      dateFormat: freezed == dateFormat
          ? _self.dateFormat
          : dateFormat // ignore: cast_nullable_to_non_nullable
              as DateFormat?,
    ));
  }
}

/// @nodoc

class Submited implements IntroEvent {
  Submited();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Submited);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'IntroEvent.submited()';
  }
}

// dart format on
