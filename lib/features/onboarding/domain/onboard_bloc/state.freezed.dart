// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntroState {
  Currency? get currency;
  int? get amountInSmallestUnits;
  Languages? get language;
  DateFormat? get dateFormat;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $IntroStateCopyWith<IntroState> get copyWith =>
      _$IntroStateCopyWithImpl<IntroState>(this as IntroState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is IntroState &&
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
    return 'IntroState(currency: $currency, amountInSmallestUnits: $amountInSmallestUnits, language: $language, dateFormat: $dateFormat)';
  }
}

/// @nodoc
abstract mixin class $IntroStateCopyWith<$Res> {
  factory $IntroStateCopyWith(
          IntroState value, $Res Function(IntroState) _then) =
      _$IntroStateCopyWithImpl;
  @useResult
  $Res call(
      {Currency? currency,
      int? amountInSmallestUnits,
      Languages? language,
      DateFormat? dateFormat});
}

/// @nodoc
class _$IntroStateCopyWithImpl<$Res> implements $IntroStateCopyWith<$Res> {
  _$IntroStateCopyWithImpl(this._self, this._then);

  final IntroState _self;
  final $Res Function(IntroState) _then;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currency = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? language = freezed,
    Object? dateFormat = freezed,
  }) {
    return _then(_self.copyWith(
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

class Initial implements IntroState {
  Initial(
      {this.currency,
      this.amountInSmallestUnits,
      this.language,
      this.dateFormat});

  @override
  final Currency? currency;
  @override
  final int? amountInSmallestUnits;
  @override
  final Languages? language;
  @override
  final DateFormat? dateFormat;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InitialCopyWith<Initial> get copyWith =>
      _$InitialCopyWithImpl<Initial>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Initial &&
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
    return 'IntroState.initial(currency: $currency, amountInSmallestUnits: $amountInSmallestUnits, language: $language, dateFormat: $dateFormat)';
  }
}

/// @nodoc
abstract mixin class $InitialCopyWith<$Res>
    implements $IntroStateCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) _then) =
      _$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Currency? currency,
      int? amountInSmallestUnits,
      Languages? language,
      DateFormat? dateFormat});
}

/// @nodoc
class _$InitialCopyWithImpl<$Res> implements $InitialCopyWith<$Res> {
  _$InitialCopyWithImpl(this._self, this._then);

  final Initial _self;
  final $Res Function(Initial) _then;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currency = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? language = freezed,
    Object? dateFormat = freezed,
  }) {
    return _then(Initial(
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

class Saving implements IntroState {
  Saving(
      {this.currency,
      this.amountInSmallestUnits,
      this.language,
      this.dateFormat});

  @override
  final Currency? currency;
  @override
  final int? amountInSmallestUnits;
  @override
  final Languages? language;
  @override
  final DateFormat? dateFormat;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavingCopyWith<Saving> get copyWith =>
      _$SavingCopyWithImpl<Saving>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Saving &&
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
    return 'IntroState.saving(currency: $currency, amountInSmallestUnits: $amountInSmallestUnits, language: $language, dateFormat: $dateFormat)';
  }
}

/// @nodoc
abstract mixin class $SavingCopyWith<$Res>
    implements $IntroStateCopyWith<$Res> {
  factory $SavingCopyWith(Saving value, $Res Function(Saving) _then) =
      _$SavingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Currency? currency,
      int? amountInSmallestUnits,
      Languages? language,
      DateFormat? dateFormat});
}

/// @nodoc
class _$SavingCopyWithImpl<$Res> implements $SavingCopyWith<$Res> {
  _$SavingCopyWithImpl(this._self, this._then);

  final Saving _self;
  final $Res Function(Saving) _then;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currency = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? language = freezed,
    Object? dateFormat = freezed,
  }) {
    return _then(Saving(
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

class Saved implements IntroState {
  Saved(
      {this.currency,
      this.amountInSmallestUnits,
      this.language,
      this.dateFormat});

  @override
  final Currency? currency;
  @override
  final int? amountInSmallestUnits;
  @override
  final Languages? language;
  @override
  final DateFormat? dateFormat;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavedCopyWith<Saved> get copyWith =>
      _$SavedCopyWithImpl<Saved>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Saved &&
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
    return 'IntroState.saved(currency: $currency, amountInSmallestUnits: $amountInSmallestUnits, language: $language, dateFormat: $dateFormat)';
  }
}

/// @nodoc
abstract mixin class $SavedCopyWith<$Res> implements $IntroStateCopyWith<$Res> {
  factory $SavedCopyWith(Saved value, $Res Function(Saved) _then) =
      _$SavedCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Currency? currency,
      int? amountInSmallestUnits,
      Languages? language,
      DateFormat? dateFormat});
}

/// @nodoc
class _$SavedCopyWithImpl<$Res> implements $SavedCopyWith<$Res> {
  _$SavedCopyWithImpl(this._self, this._then);

  final Saved _self;
  final $Res Function(Saved) _then;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currency = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? language = freezed,
    Object? dateFormat = freezed,
  }) {
    return _then(Saved(
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

class Error implements IntroState {
  Error(
      {this.e,
      this.st,
      this.currency,
      this.amountInSmallestUnits,
      this.language,
      this.dateFormat});

  final Object? e;
  final StackTrace? st;
  @override
  final Currency? currency;
  @override
  final int? amountInSmallestUnits;
  @override
  final Languages? language;
  @override
  final DateFormat? dateFormat;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ErrorCopyWith<Error> get copyWith =>
      _$ErrorCopyWithImpl<Error>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Error &&
            const DeepCollectionEquality().equals(other.e, e) &&
            (identical(other.st, st) || other.st == st) &&
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
      runtimeType,
      const DeepCollectionEquality().hash(e),
      st,
      currency,
      amountInSmallestUnits,
      language,
      dateFormat);

  @override
  String toString() {
    return 'IntroState.error(e: $e, st: $st, currency: $currency, amountInSmallestUnits: $amountInSmallestUnits, language: $language, dateFormat: $dateFormat)';
  }
}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $IntroStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) =
      _$ErrorCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Object? e,
      StackTrace? st,
      Currency? currency,
      int? amountInSmallestUnits,
      Languages? language,
      DateFormat? dateFormat});
}

/// @nodoc
class _$ErrorCopyWithImpl<$Res> implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

  /// Create a copy of IntroState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? e = freezed,
    Object? st = freezed,
    Object? currency = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? language = freezed,
    Object? dateFormat = freezed,
  }) {
    return _then(Error(
      e: freezed == e ? _self.e : e,
      st: freezed == st
          ? _self.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
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

// dart format on
