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
    Category? category,
    Money? amount,
    TransactionType? type,
    String? title,
    String? description,
  }) = Update;
  const factory CreateTransactionEvent.submit() = Submit;
  const factory CreateTransactionEvent.error({
    Object? e,
    StackTrace? st,
  }) = ErrorEvent;
  const factory CreateTransactionEvent.shouldUpdateCategories() =
      ShouldUpdateCategories;
}
