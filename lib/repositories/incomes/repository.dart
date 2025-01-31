import 'dart:async';

import 'package:cv/cv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/models/get_filter.dart';
import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
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

  // DataBase access object
  final Database db;
  // Cached values to avoid unnecessary queries
  final Map<int, Income> _cache = <int, Income>{};
  // Last sorting order applied to getList method
  bool _isDesc = false;
  // Last filter applied to getList method
  GetFilter? _filter;

  // Stream controller to emit incomes to the listeners
  late final StreamController<List<Income>> _incomesController =
      StreamController<List<Income>>.broadcast(
    onListen: () => _incomesController.sink.add(
      _cache.sortedValues(desc: _isDesc),
    ),
  );

  // Stream to listen for incomes changes
  Stream<List<Income>> get onIncomes => _incomesController.stream;

  /// Update the [_cache] with the latest incomes
  /// according to the new [_isDesc] and [_filter]
  Future<void> _updateCached() async {
    _cache.clear();

    final List<Income> incomes =
        await getList(offset: 0, limit: 20, desc: _isDesc, filter: _filter);

    for (final Income income in incomes) {
      _cache[income.id.value!] = income;
    }

    _incomesController.sink.add(_cache.sortedValues(desc: _isDesc));
  }

  /// Return the sum of all the incomes in the [duration] period,
  /// if [duration] is null, will return the sum of all the incomes
  Future<double> sumByTime({Duration? duration}) async {
    try {
      final String where = duration != null ? 'WHERE $dateColumn >= ?' : '';
      final List<Object?> whereArgs = duration != null
          ? [DateTime.now().subtract(duration).toIso8601String()]
          : [];

      final List<Map<String, Object?>> list = await db.rawQuery(
        '''
        SELECT 
          SUM($amountColumn) as sum
        FROM $tableName
        $where
        ''',
        whereArgs,
      );

      return list.first['sum'] as double? ?? 0;
    } catch (e) {
      _incomesController.addError(RepositoryException(
          "Failed to get sum by category: $e", runtimeType));
      return 0;
    }
  }

  /// Return the sum of all the incomes in the [duration] period,
  /// if [duration] is null, will return the sum of all the incomes
  /// for the given [category]
  /// if [category] is null, will return the sum of all the incomes
  Future<double> sumByCategoryAndTime(
      {Category? category, Duration? duration}) async {
    try {
      String where = "";
      final List<Object?> whereArgs = [];

      if (duration != null) {
        where += 'WHERE $dateColumn >= ?';
        whereArgs.add(DateTime.now().subtract(duration).toIso8601String());
      }
      if (category != null) {
        where += where.isNotEmpty ? ' AND ' : 'WHERE ';
        where += '$categoryIdColumn = ?';
        whereArgs.add(category.id.value);
      }

      final List<Map<String, Object?>> list = await db.rawQuery(
        '''
        SELECT 
          SUM($amountColumn) as sum
        FROM $tableName
        $where
        GROUP BY $categoryIdColumn
        ''',
        whereArgs,
      );

      return list.first['sum'] as double? ?? 0;
    } catch (e) {
      _incomesController.addError(RepositoryException(
          "Failed to get sum by category: $e", runtimeType));
      return 0;
    }
  }

  @override

  /// Will return null if item with given [id] doesn't exist
  FutureOr<Income?> getById(int id) async {
    try {
      final Income? result = _cache[id];
      if (result != null) {
        return result;
      }

      final List<Map<String, Object?>> list = await db.rawQuery(
        '''
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
        WHERE i.$idColumn = ?
        ''',
        [id],
      );

      if (list.isEmpty) {
        return null;
      }

      return Income()..fromMap(list.first);
    } catch (e) {
      _incomesController.addError(
        RepositoryException("Failed to get income: $e", runtimeType),
      );
      return null;
    }
  }

  @override

  /// Will return empty list if no items found
  /// Adds all the found items to cache
  /// and then emits it to the stream
  FutureOr<List<Income>> getList({
    int? offset,
    int? limit,
    bool desc = false,
    GetFilter? filter,
  }) async {
    try {
      if (_isDesc != desc || _filter != filter) {
        _cache.clear();
        _isDesc = desc;
        _filter = filter;
      }

      if (offset != null && limit != null && offset + limit < _cache.length) {
        final List<Income> values = _cache.sortedValues(desc: _isDesc);

        _incomesController.sink.add(values);
        return values.sublist(offset, offset + limit);
      }

      final String orderBy = '$dateColumn ${desc ? 'DESC' : 'ASC'}';
      final String limitOffset =
          (limit == null || offset == null) ? '' : 'LIMIT ? OFFSET ?';
      final List<dynamic> args = [
        ...(filter?.whereArgs ?? []),
        ...((limit == null || offset == null) ? [] : [limit, offset])
      ];

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
      ${filter?.where ?? ''}
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
    } catch (e) {
      _incomesController.addError(
        RepositoryException("Failed to get incomes: $e", runtimeType),
      );
      return <Income>[];
    }
  }

  @override

  /// If the [income] doesn't exists in the [_cache]
  /// will reset [_cache]
  /// ((old data can be not relevant anymore))
  ///
  /// Will update if [value] already exists in the database
  /// ((provided value has id))
  /// Will insert if [value] doesn't exist in the database
  Future<Income> save(Income income) async {
    try {
      if (income.id.value == null) {
        final int id = await db.insert(tableName, income.toMap());
        income.id.value = id;
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

      return income;
    } catch (e) {
      _incomesController.addError(
          RepositoryException('Failed to save income: $e', runtimeType));
      return Income();
    }
  }

  @override

  /// Will no matter what reset current cached data
  /// ((old data can be not relevant anymore))
  /// Will update if [value] already exists in the database
  /// Will insert if [value] doesn't exist in the database
  Future<List<Income>> saveAll(List<Income> incomes) async {
    try {
      final Batch batch = db.batch();

      for (final Income income in incomes) {
        if (income.id.value == null) {
          batch.insert(tableName, income.toMap());
        } else {
          batch.update(
            tableName,
            income.toMap(),
            where: '$idColumn = ?',
            whereArgs: [income.id.value],
          );
        }
      }

      final List<Object?> result = await batch.commit();

      bool needsUpdate = false;

      for (int index = 0; index < incomes.length; index++) {
        final Income income = incomes[index];
        final int? resultItem = result[index] as int?;

        if (_cache.containsKey(income.id.value)) {
          _cache[income.id.value!] = income;
        } else if (income.id.value == null) {
          income.id.value = resultItem;
          needsUpdate = true;
        } else {
          needsUpdate = true;
        }
      }

      if (needsUpdate) {
        await _updateCached();
      } else {
        _incomesController.sink.add(
          _cache.sortedValues(desc: _isDesc),
        );
      }

      return incomes;
    } catch (e) {
      _incomesController.addError(RepositoryException(
          "Failed to save all the incomes: $e", runtimeType));
      return <Income>[];
    }
  }

  @override

  /// Will no matter what reset current cached data
  /// ((old data can be not relevant anymore))
  /// Will delete item with given [id]
  Future<int> delete(Income income) async {
    try {
      final int result = await db.delete(
        tableName,
        where: '$idColumn = ?',
        whereArgs: [income.id.value],
      );

      if (_cache.remove(income.id.value) != null) {
        _incomesController.sink.add(
          _cache.sortedValues(desc: _isDesc),
        );
      } else {
        await _updateCached();
      }

      return result;
    } catch (e) {
      _incomesController.addError(
        RepositoryException("Failed to delete income: $e", runtimeType),
      );
      return 0;
    }
  }

  Future<void> dispose() async {
    return _incomesController.close();
  }
}
