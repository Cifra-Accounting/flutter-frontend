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
    Category? category,
    Money? amount,
    Currency? baseCurrency,
    TransactionType? type,
    String? title,
    String? description,
    @Default(CreateTransactionBlocState.notSubmited)
    CreateTransactionBlocState blocState,
    @Default(<Category>[]) List<Category> categories,
  }) = _CreateTransactionState;

  const factory CreateTransactionState.error({
    Object? e,
    StackTrace? st,
    Category? category,
    Money? amount,
    Currency? baseCurrency,
    TransactionType? type,
    String? title,
    String? description,
    @Default(CreateTransactionBlocState.notSubmited)
    CreateTransactionBlocState blocState,
    @Default(<Category>[]) List<Category> categories,
  }) = _ErrorCreateTransactionState;

  CreateTransactionState toError(Object? e, StackTrace? st) =>
      CreateTransactionState.error(
        e: e,
        st: st,
        category: category,
        amount: amount,
        baseCurrency: baseCurrency,
        type: type,
        title: title,
        description: description,
        blocState: blocState,
        categories: categories,
      );

  CreateTransactionState toInitial() => CreateTransactionState(
        category: category,
        amount: amount,
        baseCurrency: baseCurrency,
        type: type,
        title: title,
        description: description,
        blocState: blocState,
        categories: categories,
      );
}

enum CreateTransactionBlocState {
  notSubmited,
  loading,
  loaded,
}
