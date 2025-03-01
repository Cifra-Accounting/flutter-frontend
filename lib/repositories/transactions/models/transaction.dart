import 'package:cifra_app/common/models/money.dart';
import 'package:cv/cv.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/db_record.dart';

enum TransactionType {
  expence,
  income;
}

class Transaction extends DbRecord {
  final CvField<String> title = CvField<String>(titleColumn);
  final CvField<TransactionType> type = CvField<TransactionType>(typeColumn);
  final CvModelField<Category> category =
      CvModelField<Category>(categoryIdColumn);
  final CvField<Money> value = CvField<Money>(amountColumn);
  final CvField<DateTime> date = CvField<DateTime>(dateColumn);
  final CvField<String?> description = CvField<String?>(descriptionColumn);

  @override
  void fromMap(Map map, {List<String>? columns}) {
    super.fromMap(map, columns: columns);

    if (map.containsKey(dateColumn)) {
      date.value = DateTime.parse(map[dateColumn]);
    }
    if (map.containsKey(amountColumn)) {
      value.value = Money.fromMap(map[amountColumn]);
    }
    if (map.containsKey(typeColumn)) {
      type.value = TransactionType.values.firstWhere(
        (TransactionType type) => type.name == map[typeColumn],
        orElse: () => TransactionType.expence,
      );
    }
  }

  @override
  Map<String, Object?> toMap(
      {List<String>? columns, bool includeMissingValue = false}) {
    final Map<String, Object?> map = super.toMap(
      columns: columns,
      includeMissingValue: includeMissingValue,
    );

    if (map.containsKey(categoryIdColumn)) {
      map[categoryIdColumn] = category.value!.id.value;
    }
    if (map.containsKey(dateColumn)) {
      map[dateColumn] = date.value!.toIso8601String();
    }
    if (map.containsKey(amountColumn)) {
      map[amountColumn] = value.value!.toMap()[amountColumn];
      map[currencyColumn] = value.value!.currency.name;
    }
    if (map.containsKey(typeColumn)) {
      map[typeColumn] = type.value?.name;
    }

    return map;
  }

  @override
  CvFields get fields => [id, title, category, value, type, date, description];
}
