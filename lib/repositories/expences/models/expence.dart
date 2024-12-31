import 'package:cv/cv.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/db_record.dart';

class Expence extends DbRecord {
  final CvField<String> title = CvField<String>(titleColumn);
  final CvModelField<Category> category =
      CvModelField<Category>(categoryIdColumn);
  final CvField<double> amount = CvField<double>(amountColumn);
  final CvField<DateTime> date = CvField<DateTime>(dateColumn);
  final CvField<String?> description = CvField<String?>(descriptionColumn);

  @override
  CvFields get fields => [id, title, category, amount, date, description];

  @override
  Map<String, Object?> toMap(
      {List<String>? columns, bool includeMissingValue = false}) {
    final Map<String, Object?> map =
        super.toMap(columns: columns, includeMissingValue: includeMissingValue);

    if (map.containsKey(categoryIdColumn)) {
      map[categoryIdColumn] = category.value!.id;
    }

    return map;
  }

  @override
  void fromMap(Map map, {List<String>? columns}) {
    if (map.containsKey(categoryIconColumn) &&
        map.containsKey(categoryNameColumn)) {
      map[categoryIdColumn] = Category()
        ..id.value = map[categoryIdColumn]
        ..name.value = map[categoryNameColumn]
        ..icon.value = map[categoryIconColumn];

      map.removeWhere((key, value) =>
          key == categoryNameColumn || key == categoryIconColumn);
    }
    super.fromMap(map, columns: columns);
  }
}
