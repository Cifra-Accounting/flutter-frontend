// ignore: depend_on_referenced_packages
import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
abstract class CreateTransactionState with _$CreateTransactionState {
  const CreateTransactionState._();

  const factory CreateTransactionState({
    String? title,
    String? description,
    Category? category,
    int? amountInSmallestUnits,
    Currency? currency,
    int? amountInSmallestUnitsBase,
    required Currency baseCurrency,
    @Default(TransactionType.expence) TransactionType type,
    @Default(CreateTransactionStatus.initial) CreateTransactionStatus status,
    @Default(<Category>[]) List<Category> categories,
    @Default(false) bool shouldConvertToBase,
    Map<Currency, double>? exchangeRates,
    Object? e,
    StackTrace? st,
  }) = _CreateTransactionState;
}

enum CreateTransactionStatus {
  initial,
  loading,
  loaded,
  error;
}
