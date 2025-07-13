// ignore: depend_on_referenced_packages
import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
// ignore: depend_on_referenced_packages
import 'package:freezed_annotation/freezed_annotation.dart';

part "event.freezed.dart";

@freezed
abstract class CreateTransactionEvent with _$CreateTransactionEvent {
  const factory CreateTransactionEvent.update({
    String? title,
    String? description,
    Category? category,
    int? amountInSmallestUnits,
    Currency? currency,
    TransactionType? type,
    @Default(false) bool shouldConvertToBase,
  }) = Update;
  const factory CreateTransactionEvent.submit() = Submit;
  const factory CreateTransactionEvent.error({
    Object? e,
    StackTrace? st,
  }) = ErrorEvent;
  const factory CreateTransactionEvent.shouldUpdateCategories() =
      ShouldUpdateCategories;
}
