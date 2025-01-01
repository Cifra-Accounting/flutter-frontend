import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/expences/models/expence.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cv/cv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Expence model test", () {
    setUpAll(() {
      cvAddConstructor<Expence>(Expence.new);
      cvAddConstructor<Category>(Category.new);
    });

    test("fromMap", () {
      final Map<String, Object?> map = {
        idColumn: 1,
        categoryIdColumn: 1,
        categoryNameColumn: 'Category 1',
        categoryIconColumn: 1,
        titleColumn: 'Expence 1',
        amountColumn: 100.0,
        dateColumn: '2025-01-01T22:00:15.536590',
        descriptionColumn: null,
      };

      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      final Expence expence = Expence()..fromMap(map);

      expect(expence.id.value, 1, reason: "id fromMap");
      expect(expence.category.value, category, reason: "category fromMap");
      expect(expence.title.value, 'Expence 1', reason: "title fromMap");
      expect(expence.amount.value, 100.0, reason: "amount fromMap");
      expect(expence.date.value, DateTime.parse('2025-01-01T22:00:15.536590'),
          reason: "date fromMap");
      expect(expence.description.value, isNull, reason: "description fromMap");
    });

    test("toMap", () {
      final Category category = Category()
        ..id.value = 1
        ..name.value = 'Category 1'
        ..icon.value = 1;

      final Expence expence = Expence()
        ..id.value = 1
        ..category.value = category
        ..title.value = 'Expence 1'
        ..amount.value = 100.0
        ..date.value = DateTime.parse('2025-01-01T22:00:15.536590')
        ..description.value = null;

      final Map<String, Object?> map = expence.toMap();

      expect(map[idColumn], 1, reason: "id toMap");
      expect(map[categoryIdColumn], 1, reason: "categoryId toMap");
      expect(map[titleColumn], 'Expence 1', reason: "title toMap");
      expect(map[amountColumn], 100.0, reason: "amount toMap");
      expect(map[dateColumn], '2025-01-01T22:00:15.536590',
          reason: "date toMap");
      expect(map[descriptionColumn], isNull, reason: "description toMap");
    });
  });
}
