import 'package:cifra_app/repositories/models/money.dart';
import 'package:cv/cv.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/db_record.dart';

class Expence extends DbRecord {
  final CvField<String> title = CvField<String>(titleColumn);
  final CvModelField<Category> category =
      CvModelField<Category>(categoryIdColumn);
  final CvField<Money> transaction = CvField<Money>(amountColumn);
  final CvField<DateTime> date = CvField<DateTime>(dateColumn);
  final CvField<String?> description = CvField<String?>(descriptionColumn);

  @override
  void fromMap(Map map, {List<String>? columns}) {
    final Map newMap = {};

    for (final MapEntry entry in map.entries) {
      if (entry.key == categoryIdColumn) {
        newMap[categoryIdColumn] = {
          idColumn: entry.value,
          categoryNameColumn: map[categoryNameColumn],
          categoryIconColumn: map[categoryIconColumn],
        };
      } else if (entry.key == amountColumn) {
        newMap[amountColumn] = {
          amountColumn: entry.value,
          currencyColumn: map[currencyColumn]
        };
      } else if (entry.key != categoryNameColumn &&
          entry.key != categoryIconColumn &&
          entry.key != currencyColumn) {
        newMap[entry.key] = entry.value;
      }
    }

    super.fromMap(newMap, columns: columns);

    if (newMap.containsKey(dateColumn)) {
      date.value = DateTime.parse(map[dateColumn]);
    }
    if (newMap.containsKey(amountColumn)) {
      transaction.value = Money.fromMap(newMap[amountColumn]);
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
    if (map.containsKey(amountColumn)) {
      map[amountColumn] = transaction.value!.toMap()[amountColumn];
      map[currencyColumn] = transaction.value!.currency.name;
    }

    return map;
  }

  @override
  CvFields get fields => [id, title, category, transaction, date, description];
}
