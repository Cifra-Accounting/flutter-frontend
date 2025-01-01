import 'package:cv/cv.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/db_record.dart';

class Income extends DbRecord {
  final CvField<String> title = CvField<String>(titleColumn);
  final CvModelField<Category> category =
      CvModelField<Category>(categoryIdColumn);
  final CvField<double> amount = CvField<double>(amountColumn);
  final CvField<DateTime> date = CvField<DateTime>(dateColumn);
  final CvField<String?> description = CvField<String?>(descriptionColumn);

  @override
  void fromMap(Map map, {List<String>? columns}) {
    final Map newMap = {};

    for (MapEntry entry in map.entries) {
      if (entry.key == categoryIdColumn) {
        newMap[categoryIdColumn] = {
          idColumn: entry.value,
          categoryNameColumn: map[categoryNameColumn],
          categoryIconColumn: map[categoryIconColumn],
        };
      } else if (entry.key != categoryNameColumn &&
          entry.key != categoryIconColumn) {
        newMap[entry.key] = entry.value;
      }
    }

    super.fromMap(newMap, columns: columns);

    if (newMap.containsKey(dateColumn)) {
      date.value = DateTime.parse(map[dateColumn]);
    }
  }

  @override
  Map<String, Object?> toMap(
      {List<String>? columns, bool includeMissingValue = false}) {
    final Map<String, Object?> map =
        super.toMap(columns: columns, includeMissingValue: includeMissingValue);

    if (map.containsKey(categoryIdColumn)) {
      map[categoryIdColumn] = category.value!.id.value;
    }
    if (map.containsKey(dateColumn)) {
      map[dateColumn] = date.value!.toIso8601String();
    }

    return map;
  }

  @override
  CvFields get fields => [id, title, category, amount, date, description];
}
