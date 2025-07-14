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
mixin _$CreateTransactionState {
  String? get title;
  String? get description;
  Category? get category;
  int? get amountInSmallestUnits;
  Currency? get currency;
  int? get amountInSmallestUnitsBase;
  Currency get baseCurrency;
  TransactionType get type;
  CreateTransactionStatus get status;
  List<Category> get categories;
  bool get shouldConvertToBase;
  Map<Currency, double>? get exchangeRates;
  Object? get e;
  StackTrace? get st;

  /// Create a copy of CreateTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateTransactionStateCopyWith<CreateTransactionState> get copyWith =>
      _$CreateTransactionStateCopyWithImpl<CreateTransactionState>(
          this as CreateTransactionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateTransactionState &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amountInSmallestUnits, amountInSmallestUnits) ||
                other.amountInSmallestUnits == amountInSmallestUnits) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.amountInSmallestUnitsBase,
                    amountInSmallestUnitsBase) ||
                other.amountInSmallestUnitsBase == amountInSmallestUnitsBase) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.shouldConvertToBase, shouldConvertToBase) ||
                other.shouldConvertToBase == shouldConvertToBase) &&
            const DeepCollectionEquality()
                .equals(other.exchangeRates, exchangeRates) &&
            const DeepCollectionEquality().equals(other.e, e) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      category,
      amountInSmallestUnits,
      currency,
      amountInSmallestUnitsBase,
      baseCurrency,
      type,
      status,
      const DeepCollectionEquality().hash(categories),
      shouldConvertToBase,
      const DeepCollectionEquality().hash(exchangeRates),
      const DeepCollectionEquality().hash(e),
      st);

  @override
  String toString() {
    return 'CreateTransactionState(title: $title, description: $description, category: $category, amountInSmallestUnits: $amountInSmallestUnits, currency: $currency, amountInSmallestUnitsBase: $amountInSmallestUnitsBase, baseCurrency: $baseCurrency, type: $type, status: $status, categories: $categories, shouldConvertToBase: $shouldConvertToBase, exchangeRates: $exchangeRates, e: $e, st: $st)';
  }
}

/// @nodoc
abstract mixin class $CreateTransactionStateCopyWith<$Res> {
  factory $CreateTransactionStateCopyWith(CreateTransactionState value,
          $Res Function(CreateTransactionState) _then) =
      _$CreateTransactionStateCopyWithImpl;
  @useResult
  $Res call(
      {String? title,
      String? description,
      Category? category,
      int? amountInSmallestUnits,
      Currency? currency,
      int? amountInSmallestUnitsBase,
      Currency baseCurrency,
      TransactionType type,
      CreateTransactionStatus status,
      List<Category> categories,
      bool shouldConvertToBase,
      Map<Currency, double>? exchangeRates,
      Object? e,
      StackTrace? st});
}

/// @nodoc
class _$CreateTransactionStateCopyWithImpl<$Res>
    implements $CreateTransactionStateCopyWith<$Res> {
  _$CreateTransactionStateCopyWithImpl(this._self, this._then);

  final CreateTransactionState _self;
  final $Res Function(CreateTransactionState) _then;

  /// Create a copy of CreateTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? currency = freezed,
    Object? amountInSmallestUnitsBase = freezed,
    Object? baseCurrency = null,
    Object? type = null,
    Object? status = null,
    Object? categories = null,
    Object? shouldConvertToBase = null,
    Object? exchangeRates = freezed,
    Object? e = freezed,
    Object? st = freezed,
  }) {
    return _then(_self.copyWith(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      amountInSmallestUnits: freezed == amountInSmallestUnits
          ? _self.amountInSmallestUnits
          : amountInSmallestUnits // ignore: cast_nullable_to_non_nullable
              as int?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      amountInSmallestUnitsBase: freezed == amountInSmallestUnitsBase
          ? _self.amountInSmallestUnitsBase
          : amountInSmallestUnitsBase // ignore: cast_nullable_to_non_nullable
              as int?,
      baseCurrency: null == baseCurrency
          ? _self.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as Currency,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as CreateTransactionStatus,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      shouldConvertToBase: null == shouldConvertToBase
          ? _self.shouldConvertToBase
          : shouldConvertToBase // ignore: cast_nullable_to_non_nullable
              as bool,
      exchangeRates: freezed == exchangeRates
          ? _self.exchangeRates
          : exchangeRates // ignore: cast_nullable_to_non_nullable
              as Map<Currency, double>?,
      e: freezed == e ? _self.e : e,
      st: freezed == st
          ? _self.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _CreateTransactionState extends CreateTransactionState {
  const _CreateTransactionState(
      {this.title,
      this.description,
      this.category,
      this.amountInSmallestUnits,
      this.currency,
      this.amountInSmallestUnitsBase,
      required this.baseCurrency,
      this.type = TransactionType.expence,
      this.status = CreateTransactionStatus.initial,
      final List<Category> categories = const <Category>[],
      this.shouldConvertToBase = false,
      final Map<Currency, double>? exchangeRates,
      this.e,
      this.st})
      : _categories = categories,
        _exchangeRates = exchangeRates,
        super._();

  @override
  final String? title;
  @override
  final String? description;
  @override
  final Category? category;
  @override
  final int? amountInSmallestUnits;
  @override
  final Currency? currency;
  @override
  final int? amountInSmallestUnitsBase;
  @override
  final Currency baseCurrency;
  @override
  @JsonKey()
  final TransactionType type;
  @override
  @JsonKey()
  final CreateTransactionStatus status;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final bool shouldConvertToBase;
  final Map<Currency, double>? _exchangeRates;
  @override
  Map<Currency, double>? get exchangeRates {
    final value = _exchangeRates;
    if (value == null) return null;
    if (_exchangeRates is EqualUnmodifiableMapView) return _exchangeRates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final Object? e;
  @override
  final StackTrace? st;

  /// Create a copy of CreateTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateTransactionStateCopyWith<_CreateTransactionState> get copyWith =>
      __$CreateTransactionStateCopyWithImpl<_CreateTransactionState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateTransactionState &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amountInSmallestUnits, amountInSmallestUnits) ||
                other.amountInSmallestUnits == amountInSmallestUnits) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.amountInSmallestUnitsBase,
                    amountInSmallestUnitsBase) ||
                other.amountInSmallestUnitsBase == amountInSmallestUnitsBase) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.shouldConvertToBase, shouldConvertToBase) ||
                other.shouldConvertToBase == shouldConvertToBase) &&
            const DeepCollectionEquality()
                .equals(other._exchangeRates, _exchangeRates) &&
            const DeepCollectionEquality().equals(other.e, e) &&
            (identical(other.st, st) || other.st == st));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      description,
      category,
      amountInSmallestUnits,
      currency,
      amountInSmallestUnitsBase,
      baseCurrency,
      type,
      status,
      const DeepCollectionEquality().hash(_categories),
      shouldConvertToBase,
      const DeepCollectionEquality().hash(_exchangeRates),
      const DeepCollectionEquality().hash(e),
      st);

  @override
  String toString() {
    return 'CreateTransactionState(title: $title, description: $description, category: $category, amountInSmallestUnits: $amountInSmallestUnits, currency: $currency, amountInSmallestUnitsBase: $amountInSmallestUnitsBase, baseCurrency: $baseCurrency, type: $type, status: $status, categories: $categories, shouldConvertToBase: $shouldConvertToBase, exchangeRates: $exchangeRates, e: $e, st: $st)';
  }
}

/// @nodoc
abstract mixin class _$CreateTransactionStateCopyWith<$Res>
    implements $CreateTransactionStateCopyWith<$Res> {
  factory _$CreateTransactionStateCopyWith(_CreateTransactionState value,
          $Res Function(_CreateTransactionState) _then) =
      __$CreateTransactionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? title,
      String? description,
      Category? category,
      int? amountInSmallestUnits,
      Currency? currency,
      int? amountInSmallestUnitsBase,
      Currency baseCurrency,
      TransactionType type,
      CreateTransactionStatus status,
      List<Category> categories,
      bool shouldConvertToBase,
      Map<Currency, double>? exchangeRates,
      Object? e,
      StackTrace? st});
}

/// @nodoc
class __$CreateTransactionStateCopyWithImpl<$Res>
    implements _$CreateTransactionStateCopyWith<$Res> {
  __$CreateTransactionStateCopyWithImpl(this._self, this._then);

  final _CreateTransactionState _self;
  final $Res Function(_CreateTransactionState) _then;

  /// Create a copy of CreateTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? amountInSmallestUnits = freezed,
    Object? currency = freezed,
    Object? amountInSmallestUnitsBase = freezed,
    Object? baseCurrency = null,
    Object? type = null,
    Object? status = null,
    Object? categories = null,
    Object? shouldConvertToBase = null,
    Object? exchangeRates = freezed,
    Object? e = freezed,
    Object? st = freezed,
  }) {
    return _then(_CreateTransactionState(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      amountInSmallestUnits: freezed == amountInSmallestUnits
          ? _self.amountInSmallestUnits
          : amountInSmallestUnits // ignore: cast_nullable_to_non_nullable
              as int?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency?,
      amountInSmallestUnitsBase: freezed == amountInSmallestUnitsBase
          ? _self.amountInSmallestUnitsBase
          : amountInSmallestUnitsBase // ignore: cast_nullable_to_non_nullable
              as int?,
      baseCurrency: null == baseCurrency
          ? _self.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as Currency,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as CreateTransactionStatus,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      shouldConvertToBase: null == shouldConvertToBase
          ? _self.shouldConvertToBase
          : shouldConvertToBase // ignore: cast_nullable_to_non_nullable
              as bool,
      exchangeRates: freezed == exchangeRates
          ? _self._exchangeRates
          : exchangeRates // ignore: cast_nullable_to_non_nullable
              as Map<Currency, double>?,
      e: freezed == e ? _self.e : e,
      st: freezed == st
          ? _self.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

// dart format on
