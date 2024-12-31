import 'dart:async';

import 'package:cv/cv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/incomes/models/income.dart';

import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';

extension SortedIncomeValues<K, V extends Income> on Map<K, V> {
  List<V> sortedValues({bool desc = false}) {
    final List<V> sortedValues = values.toList();

    sortedValues.sort((V a, V b) =>
        (a.date.value!.compareTo(b.date.value!)) * (desc ? -1 : 1));

    return sortedValues;
  }
}

class IncomeRepository implements Repository<Income> {
  static const String tableName = "incomes";
  static const String createQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
      $categoryIdColumn INTEGER NOT NULL,
      $titleColumn TEXT NOT NULL,
      $amountColumn REAL NOT NULL,
      $dateColumn DATETIME NOT NULL,
      $descriptionColumn TEXT DEFAULT '',
      CONSTRAINT category_idx
        FOREIGN KEY ($categoryIdColumn)
        REFERENCES ${CategoryRepository.tableName} ($idColumn)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    );
  ''';
  static const String indexQuery = '''
    CREATE INDEX IF NOT EXISTS ${tableName}_date_idx
    ON $tableName ($dateColumn);
  ''';

  IncomeRepository({
    required this.db,
  });

  final Database db;
  final Map<int, Income> _cache = <int, Income>{};
  bool _isDesc = false;

  late final StreamController<List<Income>> _incomesController =
      StreamController<List<Income>>.broadcast(
    onListen: () => _incomesController.sink.add(
      _cache.sortedValues(desc: _isDesc),
    ),
  );

  Stream<List<Income>> get onIncomes => _incomesController.stream;

  Future<void> _updateCached() async {
    _cache.clear();
    final List<Income> incomes =
        await getList(offset: 0, limit: 20, desc: _isDesc);
    for (final Income income in incomes) {
      _cache[income.id.value!] = income;
    }
    _incomesController.sink.add(_cache.sortedValues(desc: _isDesc));
  }

  @override

  /// Will return null if item with given [id] doesn't exist
  FutureOr<Income?> getById(int id) async {
    final Income? result = _cache[id];
    if (result != null) {
      return result;
    }

    final List<Map<String, Object?>> list = await db.rawQuery('''
      SELECT
        i.$idColumn as $idColumn,
        i.$categoryIdColumn as $categoryIdColumn,
        c.$categoryNameColumn as $categoryNameColumn,
        c.$categoryIconColumn as $categoryIconColumn,
        i.$titleColumn as $titleColumn,
        i.$amountColumn as $amountColumn,
        i.$dateColumn as $dateColumn, 
        i.$descriptionColumn as $descriptionColumn
      FROM $tableName i
      JOIN ${CategoryRepository.tableName} c ON i.$categoryIdColumn = c.$idColumn
      WHERE i.$idColumn = $id
    ''');

    if (list.isEmpty) {
      return null;
    }
    return Income()..fromMap(list.first);
  }

  @override

  /// Will return empty list if no items found
  /// Adds all the found items to cache
  /// and then emits it to the stream
  FutureOr<List<Income>> getList({
    int? offset,
    int? limit,
    bool desc = false,
  }) async {
    if (_isDesc != desc) {
      _cache.clear();
      _isDesc = desc;
    }
    if (offset != null && limit != null && offset + limit < _cache.length) {
      _incomesController.sink.add(
        _cache.sortedValues(desc: _isDesc),
      );
      return _cache.sortedValues(desc: _isDesc).sublist(offset, offset + limit);
    }

    final String orderBy = '$dateColumn ${desc ? 'DESC' : 'ASC'}';
    String limitOffset = '';
    final List<dynamic> args = [];

    if (limit != null && offset != null) {
      limitOffset = 'LIMIT ? OFFSET ?';
      args.add(limit);
      args.add(offset);
    }

    final String query = '''
      SELECT
        i.$idColumn as $idColumn,
        i.$categoryIdColumn as $categoryIdColumn,
        c.$categoryNameColumn as $categoryNameColumn,
        c.$categoryIconColumn as $categoryIconColumn,
        i.$titleColumn as $titleColumn,
        i.$amountColumn as $amountColumn,
        i.$dateColumn as $dateColumn,
        i.$descriptionColumn as $descriptionColumn
      FROM $tableName i
      JOIN ${CategoryRepository.tableName} c ON i.$categoryIdColumn = c.$idColumn
      ORDER BY $orderBy
      $limitOffset
    ''';

    final List<Map<String, dynamic>> results = await db.rawQuery(query, args);

    final List<Income> incomes = results.cv<Income>();

    for (final Income income in incomes) {
      _cache[income.id.value!] = income;
    }

    _incomesController.sink.add(
      _cache.sortedValues(desc: _isDesc),
    );

    return incomes;
  }

  @override

  /// If the [income] doesn't exists in the [_cache]
  /// will reset [_cache]
  /// ((old data can be not relevant anymore))
  ///
  /// Will update if [value] already exists in the database
  /// ((provided value has id))
  /// Will insert if [value] doesn't exist in the database
  Future<void> save(Income income) async {
    try {
      if (income.id.value == null) {
        await db.insert(tableName, income.toMap());
      } else {
        await db.update(
          tableName,
          income.toMap(),
          where: '$idColumn = ?',
          whereArgs: [income.id.value!],
        );
      }

      if (_cache.containsKey(income.id.value)) {
        _cache[income.id.value!] = income;
        _incomesController.sink.add(
          _cache.sortedValues(desc: _isDesc),
        );
      } else {
        await _updateCached();
      }
    } catch (e) {
      throw RepositoryException('Failed to save income: $e', runtimeType);
    }
  }

  @override

  /// Will no matter what reset current cached data
  /// ((old data can be not relevant anymore))
  /// Will update if [value] already exists in the database
  /// Will insert if [value] doesn't exist in the database
  Future saveAll(List<Income> incomes) async {
    final Batch batch = db.batch();

    try {
      for (final Income income in incomes) {
        if (income.id.value == null) {
          batch.insert(tableName, income.toMap());
        } else {
          batch.update(tableName, income.toMap(),
              where: '$idColumn = ?', whereArgs: [income.id.value]);
        }
      }

      await batch.commit(noResult: true);

      for (final Income income in incomes) {
        if (_cache.containsKey(income.id.value)) {
          _cache[income.id.value!] = income;
        } else {
          return await _updateCached();
        }
      }

      _incomesController.sink.add(
        _cache.sortedValues(desc: _isDesc),
      );
    } catch (e) {
      throw RepositoryException(
          "Failed to save all the incomes: $e", runtimeType);
    }
  }

  @override

  /// Will no matter what reset current cached data
  /// ((old data can be not relevant anymore))
  /// Will delete item with given [id]
  Future delete(int id) async {
    await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
    if (_cache.containsKey(id)) {
      _cache.remove(id);
      _incomesController.sink.add(
        _cache.sortedValues(desc: _isDesc),
      );
    } else {
      await _updateCached();
    }
  }

  void dispose() {
    _incomesController.close();
  }
}
