import 'package:cifra_app/repositories/models/money.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cv/cv.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/incomes/models/income.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';

void main() {
  group("Income model test", () {
    setUpAll(() {
      cvAddConstructor<Income>(Income.new);
      cvAddConstructor<Category>(Category.new);
    });

    test("Test fromMap method", () {
      final Map<String, Object?> map = {
        idColumn: 1,
        categoryIdColumn: 1,
        categoryNameColumn: 'Category 1',
        categoryIconColumn: 1,
        titleColumn: 'Income 1',
        amountColumn: 100,
        currencyColumn: 'usd',
        dateColumn: '2025-01-01T22:00:15.536590',
        descriptionColumn: null,
      };

      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      const Money transaction = Money(
        amountInSmallestUnits: 100,
        currency: Currency.usd,
      );

      final Income income = Income()..fromMap(map);

      expect(income.id.value, map[idColumn], reason: "id fromMap");
      expect(income.category.value, category, reason: "category fromMap");
      expect(income.title.value, map[titleColumn], reason: "title fromMap");
      expect(income.transaction.value, transaction,
          reason: "transaction fromMap");
      expect(income.date.value, DateTime.parse(map[dateColumn] as String),
          reason: "date fromMap");
      expect(income.description.value, isNull, reason: "description fromMap");
    });

    test("Test toMap method", () {
      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      const Money transaction = Money(
        amountInSmallestUnits: 100,
        currency: Currency.usd,
      );

      final Income income = Income()
        ..id.value = 1
        ..category.value = category
        ..title.value = 'Income 1'
        ..transaction.value = transaction
        ..date.value = DateTime.parse('2025-01-01T22:00:15.536590')
        ..description.value = null;

      final Map<String, Object?> map = income.toMap();

      expect(map[idColumn], income.id.value, reason: "id toMap");
      expect(map[categoryIdColumn], income.category.value!.id.value,
          reason: "categoryId toMap");
      expect(map[titleColumn], income.title.value, reason: "title toMap");
      expect(map[amountColumn], income.transaction.value!.toMap()[amountColumn],
          reason: "amount toMap");
      expect(map[currencyColumn], income.transaction.value!.currency.name,
          reason: "currency toMap");
      expect(map[dateColumn], income.date.value!.toIso8601String(),
          reason: "date toMap");
      expect(map[descriptionColumn], isNull, reason: "description toMap");
    });
  });
}
