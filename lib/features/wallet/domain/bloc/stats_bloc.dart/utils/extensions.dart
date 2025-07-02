import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';

extension ReducableTransactionList on List<Transaction> {
  Money? reduceTransactions({required Currency baseCurrency}) {
    Money? money;

    for (final Transaction transaction in this) {
      if (transaction.value.value?.currency != baseCurrency) continue;

      if (money == null) {
        money = transaction.value.value;
        continue;
      }
      money += transaction.value.value ?? 0;
    }

    return money;
  }
}
