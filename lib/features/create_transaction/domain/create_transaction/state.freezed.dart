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
  Category? get category;
  Money? get amount;
  Currency? get baseCurrency;
  TransactionType? get type;
  String? get title;
  String? get description;
  CreateTransactionBlocState get blocState;
  List<Category> get categories;

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
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.blocState, blocState) ||
                other.blocState == blocState) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      category,
      amount,
      baseCurrency,
      type,
      title,
      description,
      blocState,
      const DeepCollectionEquality().hash(categories));

  @override
  String toString() {
    return 'CreateTransactionState(category: $category, amount: $amount, baseCurrency: $baseCurrency, type: $type, title: $title, description: $description, blocState: $blocState, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class $CreateTransactionStateCopyWith<$Res> {
  factory $CreateTransactionStateCopyWith(CreateTransactionState value,
          $Res Function(CreateTransactionState) _then) =
      _$CreateTransactionStateCopyWithImpl;
  @useResult
  $Res call(
      {Category? category,
      Money? amount,
      Currency? baseCurrency,
      TransactionType? type,
      String? title,
      String? description,
      CreateTransactionBlocState blocState,
      List<Category> categories});
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
    Object? category = freezed,
    Object? amount = freezed,
    Object? baseCurrency = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? blocState = null,
    Object? categories = null,
  }) {
    return _then(_self.copyWith(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money?,
      baseCurrency: freezed == baseCurrency
          ? _self.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as Currency?,
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
      blocState: null == blocState
          ? _self.blocState
          : blocState // ignore: cast_nullable_to_non_nullable
              as CreateTransactionBlocState,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _CreateTransactionState extends CreateTransactionState {
  const _CreateTransactionState(
      {this.category,
      this.amount,
      this.baseCurrency,
      this.type,
      this.title,
      this.description,
      this.blocState = CreateTransactionBlocState.notSubmited,
      final List<Category> categories = const <Category>[]})
      : _categories = categories,
        super._();

  @override
  final Category? category;
  @override
  final Money? amount;
  @override
  final Currency? baseCurrency;
  @override
  final TransactionType? type;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey()
  final CreateTransactionBlocState blocState;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

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
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.blocState, blocState) ||
                other.blocState == blocState) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      category,
      amount,
      baseCurrency,
      type,
      title,
      description,
      blocState,
      const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'CreateTransactionState(category: $category, amount: $amount, baseCurrency: $baseCurrency, type: $type, title: $title, description: $description, blocState: $blocState, categories: $categories)';
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
      {Category? category,
      Money? amount,
      Currency? baseCurrency,
      TransactionType? type,
      String? title,
      String? description,
      CreateTransactionBlocState blocState,
      List<Category> categories});
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
    Object? category = freezed,
    Object? amount = freezed,
    Object? baseCurrency = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? blocState = null,
    Object? categories = null,
  }) {
    return _then(_CreateTransactionState(
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money?,
      baseCurrency: freezed == baseCurrency
          ? _self.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as Currency?,
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
      blocState: null == blocState
          ? _self.blocState
          : blocState // ignore: cast_nullable_to_non_nullable
              as CreateTransactionBlocState,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

/// @nodoc

class _ErrorCreateTransactionState extends CreateTransactionState {
  const _ErrorCreateTransactionState(
      {this.e,
      this.st,
      this.category,
      this.amount,
      this.baseCurrency,
      this.type,
      this.title,
      this.description,
      this.blocState = CreateTransactionBlocState.notSubmited,
      final List<Category> categories = const <Category>[]})
      : _categories = categories,
        super._();

  final Object? e;
  final StackTrace? st;
  @override
  final Category? category;
  @override
  final Money? amount;
  @override
  final Currency? baseCurrency;
  @override
  final TransactionType? type;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey()
  final CreateTransactionBlocState blocState;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// Create a copy of CreateTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ErrorCreateTransactionStateCopyWith<_ErrorCreateTransactionState>
      get copyWith => __$ErrorCreateTransactionStateCopyWithImpl<
          _ErrorCreateTransactionState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ErrorCreateTransactionState &&
            const DeepCollectionEquality().equals(other.e, e) &&
            (identical(other.st, st) || other.st == st) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.blocState, blocState) ||
                other.blocState == blocState) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(e),
      st,
      category,
      amount,
      baseCurrency,
      type,
      title,
      description,
      blocState,
      const DeepCollectionEquality().hash(_categories));

  @override
  String toString() {
    return 'CreateTransactionState.error(e: $e, st: $st, category: $category, amount: $amount, baseCurrency: $baseCurrency, type: $type, title: $title, description: $description, blocState: $blocState, categories: $categories)';
  }
}

/// @nodoc
abstract mixin class _$ErrorCreateTransactionStateCopyWith<$Res>
    implements $CreateTransactionStateCopyWith<$Res> {
  factory _$ErrorCreateTransactionStateCopyWith(
          _ErrorCreateTransactionState value,
          $Res Function(_ErrorCreateTransactionState) _then) =
      __$ErrorCreateTransactionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Object? e,
      StackTrace? st,
      Category? category,
      Money? amount,
      Currency? baseCurrency,
      TransactionType? type,
      String? title,
      String? description,
      CreateTransactionBlocState blocState,
      List<Category> categories});
}

/// @nodoc
class __$ErrorCreateTransactionStateCopyWithImpl<$Res>
    implements _$ErrorCreateTransactionStateCopyWith<$Res> {
  __$ErrorCreateTransactionStateCopyWithImpl(this._self, this._then);

  final _ErrorCreateTransactionState _self;
  final $Res Function(_ErrorCreateTransactionState) _then;

  /// Create a copy of CreateTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? e = freezed,
    Object? st = freezed,
    Object? category = freezed,
    Object? amount = freezed,
    Object? baseCurrency = freezed,
    Object? type = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? blocState = null,
    Object? categories = null,
  }) {
    return _then(_ErrorCreateTransactionState(
      e: freezed == e ? _self.e : e,
      st: freezed == st
          ? _self.st
          : st // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as Money?,
      baseCurrency: freezed == baseCurrency
          ? _self.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as Currency?,
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
      blocState: null == blocState
          ? _self.blocState
          : blocState // ignore: cast_nullable_to_non_nullable
              as CreateTransactionBlocState,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
    ));
  }
}

// dart format on
