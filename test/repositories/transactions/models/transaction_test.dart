import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/common/models/money.dart';
import 'package:cv/cv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Transaction model test", () {
    setUpAll(() {
      cvAddConstructor<Transaction>(Transaction.new);
      cvAddConstructor<Category>(Category.new);
    });

    test("fromMap", () {
      final Map<String, Object?> map = {
        idColumn: 1,
        categoryIdColumn: <String, dynamic>{
          idColumn: 1,
          categoryNameColumn: 'Category 1',
          categoryIconColumn: 1,
        },
        titleColumn: 'Transaction 1',
        typeColumn: 'expence',
        amountColumn: <String, dynamic>{
          amountColumn: 100,
          currencyColumn: 'usd',
        },
        dateColumn: '2025-01-01T22:00:15.536590',
        descriptionColumn: null,
      };

      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      const Money transactionAmount = Money(
        amountInSmallestUnits: 100,
        currency: Currency.usd,
      );

      final Transaction transaction = Transaction()..fromMap(map);

      expect(transaction.id.value, map[idColumn], reason: "id fromMap");
      expect(transaction.category.value, category, reason: "category fromMap");
      expect(transaction.title.value, map[titleColumn],
          reason: "title fromMap");
      expect(transaction.value.value, transactionAmount,
          reason: "transactionAmount fromMap");
      expect(transaction.type.value, TransactionType.expence,
          reason: "type fromMap");
      expect(transaction.date.value, DateTime.parse(map[dateColumn] as String),
          reason: "date fromMap");
      expect(transaction.description.value, isNull,
          reason: "description fromMap");
    });

    test("toMap", () {
      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      const Money transactionAmount = Money(
        amountInSmallestUnits: 100,
        currency: Currency.usd,
      );

      final Transaction transaction = Transaction()
        ..id.value = 1
        ..category.value = category
        ..title.value = 'Transaction 1'
        ..value.value = transactionAmount
        ..type.value = TransactionType.income
        ..date.value = DateTime.parse('2025-01-01T22:00:15.536590')
        ..description.value = null;

      final Map<String, Object?> map = transaction.toMap();

      expect(map[idColumn], transaction.id.value, reason: "id toMap");
      expect(map[categoryIdColumn], transaction.category.value!.id.value,
          reason: "categoryId toMap");
      expect(map[titleColumn], transaction.title.value, reason: "title toMap");
      expect(map[amountColumn], transaction.value.value!.toMap()[amountColumn],
          reason: "amount toMap");
      expect(map[typeColumn], transaction.type.value!.name,
          reason: "type toMap");
      expect(map[currencyColumn], transaction.value.value!.currency.name,
          reason: "currency toMap");
      expect(map[dateColumn], transaction.date.value!.toIso8601String(),
          reason: "date toMap");
      expect(map[descriptionColumn], isNull, reason: "description toMap");
    });
  });
}
