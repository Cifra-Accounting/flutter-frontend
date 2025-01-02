import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cv/cv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Category model test", () {
    setUpAll(() {
      cvAddConstructor<Category>(Category.new);
    });

    test("fromMap", () {
      final Map<String, Object?> map = {
        idColumn: 1,
        categoryNameColumn: 'Category 1',
        categoryIconColumn: 1,
      };

      final Category category = Category()..fromMap(map);

      expect(category.id.value, map[idColumn], reason: "id fromMap");
      expect(category.name.value, map[categoryNameColumn],
          reason: "name fromMap");
      expect(category.icon.value, map[categoryIconColumn],
          reason: "icon fromMap");
    });
  });

  test("toMap", () {
    final Category category = Category()
      ..id.value = 1
      ..name.value = 'Category 1'
      ..icon.value = 1;

    final Map<String, Object?> map = category.toMap();

    expect(map[idColumn], category.id.value, reason: "id toMap");
    expect(map[categoryNameColumn], category.name.value, reason: "name toMap");
    expect(map[categoryIconColumn], category.icon.value, reason: "icon toMap");
  });
}
