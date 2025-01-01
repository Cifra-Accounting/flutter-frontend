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
        amountColumn: 100.0,
        dateColumn: '2025-01-01T22:00:15.536590',
        descriptionColumn: null,
      };

      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      final Income income = Income()..fromMap(map);

      expect(income.id.value, 1, reason: "id fromMap");
      expect(income.category.value, category, reason: "category fromMap");
      expect(income.title.value, 'Income 1', reason: "title fromMap");
      expect(income.amount.value, 100.0, reason: "amount fromMap");
      expect(income.date.value, DateTime.parse('2025-01-01T22:00:15.536590'),
          reason: "date fromMap");
      expect(income.description.value, isNull, reason: "description fromMap");
    });

    test("Test toMap method", () {
      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      final Income income = Income()
        ..id.value = 1
        ..category.value = category
        ..title.value = 'Income 1'
        ..amount.value = 100.0
        ..date.value = DateTime.parse('2025-01-01T22:00:15.536590')
        ..description.value = null;

      final Map<String, Object?> map = income.toMap();

      expect(map[idColumn], 1, reason: "id toMap");
      expect(map[categoryIdColumn], 1, reason: "category toMap");
      expect(map[titleColumn], 'Income 1', reason: "title toMap");
      expect(map[amountColumn], 100.0, reason: "amount toMap");
      expect(map[dateColumn], '2025-01-01T22:00:15.536590',
          reason: "date toMap");
      expect(map[descriptionColumn], isNull, reason: "description toMap");
    });
  });
}
