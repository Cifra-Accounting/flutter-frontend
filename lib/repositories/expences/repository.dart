import 'dart:async';

import 'package:cv/cv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/models/get_filter.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/expences/models/expence.dart';

import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';

extension SortedExpenceValues<K, V extends Expence> on Map<K, V> {
  List<V> sortedValues({bool desc = false}) {
    final List<V> sortedValues = values.toList();

    sortedValues.sort((V a, V b) =>
        (a.date.value!.compareTo(b.date.value!)) * (desc ? -1 : 1));

    return sortedValues;
  }
}

class ExpenceRepository implements Repository<Expence> {
  static const String tableName = "expences";
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

  ExpenceRepository({required this.db});

  final Database db;
  final Map<int, Expence> _cache = <int, Expence>{};
  bool _isDesc = false;

  late final StreamController<List<Expence>> _expencesController =
      StreamController<List<Expence>>.broadcast(
    onListen: () => _expencesController.sink.add(
      _cache.sortedValues(desc: _isDesc),
    ),
  );

  Stream<List<Expence>> get onExpences => _expencesController.stream;

  Future<void> _updateCached() async {
    _cache.clear();

    final List<Expence> expences =
        await getList(offset: 0, limit: 20, desc: _isDesc)
          ..forEach((Expence expence) => _cache[expence.id.value!] = expence);

    _expencesController.sink.add(expences);
  }

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
      _expencesController.addError(RepositoryException(
          "Failed to get sum by category: $e", runtimeType));
      return 0;
    }
  }

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
      _expencesController.addError(RepositoryException(
          "Failed to get sum by category: $e", runtimeType));
      return 0;
    }
  }

  @override
  FutureOr<Expence?> getById(int id) async {
    final Expence? result = _cache[id];
    try {
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
      return Expence()..fromMap(list.first);
    } catch (e) {
      _expencesController.addError(
        RepositoryException("Failed to get expence: $e", runtimeType),
      );
      return null;
    }
  }

  @override
  Future<List<Expence>> getList({
    int? offset,
    int? limit,
    bool desc = false,
    GetFilter? filter,
  }) async {
    try {
      if (_isDesc != desc) {
        _cache.clear();
        _isDesc = desc;
      }
      if (offset != null && limit != null && offset + limit < _cache.length) {
        _expencesController.sink.add(
          _cache.sortedValues(desc: _isDesc),
        );
        return _cache
            .sortedValues(desc: _isDesc)
            .sublist(offset, offset + limit);
      }

      final String orderBy = '$dateColumn ${desc ? 'DESC' : 'ASC'}';
      final String limitOffset =
          (limit == null || offset == null) ? '' : 'LIMIT ? OFFSET ?';
      final List<dynamic> args =
          (limit == null || offset == null) ? [] : [limit, offset];

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

      final List<Expence> expences = results.cv<Expence>();

      for (final Expence expence in expences) {
        _cache[expence.id.value!] = expence;
      }

      _expencesController.sink.add(
        _cache.sortedValues(desc: _isDesc),
      );

      return expences;
    } catch (e) {
      _expencesController.addError(
        RepositoryException("Failed to get expences: $e", runtimeType),
      );
      return <Expence>[];
    }
  }

  @override
  Future<Expence> save(Expence expence) async {
    try {
      if (expence.id.value == null) {
        final int id = await db.insert(tableName, expence.toMap());
        expence.id.value = id;
      } else {
        await db.update(
          tableName,
          expence.toMap(),
          where: '$idColumn = ?',
          whereArgs: [expence.id.value],
        );
      }

      if (_cache.containsKey(expence.id.value)) {
        _cache[expence.id.value!] = expence;
        _expencesController.sink.add(
          _cache.sortedValues(desc: _isDesc),
        );
      } else {
        await _updateCached();
      }

      return expence;
    } catch (e) {
      _expencesController.addError(
          RepositoryException('Failed to save income: $e', runtimeType));
      return Expence();
    }
  }

  @override
  Future<List<Expence>> saveAll(List<Expence> expences) async {
    try {
      final Batch batch = db.batch();

      for (final Expence expence in expences) {
        if (expence.id.value == null) {
          batch.insert(tableName, expence.toMap());
        } else {
          batch.update(
            tableName,
            expence.toMap(),
            where: '$idColumn = ?',
            whereArgs: [expence.id.value],
          );
        }
      }

      final List<Object?> result = await batch.commit();

      bool needsUpdate = false;

      for (int index = 0; index < expences.length; index++) {
        final Expence expence = expences[index];
        final int? resultItem = result[index] as int?;

        if (_cache.containsKey(expence.id.value)) {
          _cache[expence.id.value!] = expence;
        } else if (expence.id.value == null) {
          expence.id.value = resultItem;
          needsUpdate = true;
        } else {
          needsUpdate = true;
        }
      }

      if (needsUpdate) {
        await _updateCached();
      } else {
        _expencesController.sink.add(
          _cache.sortedValues(desc: _isDesc),
        );
      }

      return expences;
    } catch (e) {
      _expencesController.addError(RepositoryException(
          "Failed to save all the incomes: $e", runtimeType));
      return <Expence>[];
    }
  }

  @override
  Future<int> delete(Expence expence) async {
    try {
      final int result = await db.delete(
        tableName,
        where: '$idColumn = ?',
        whereArgs: [expence.id.value],
      );

      if (_cache.remove(expence.id.value!) != null) {
        _expencesController.sink.add(
          _cache.sortedValues(desc: _isDesc),
        );
      } else {
        await _updateCached();
      }

      return result;
    } catch (e) {
      _expencesController.addError(
        RepositoryException("Failed to delete expence: $e", runtimeType),
      );
      return 0;
    }
  }

  Future<void> dispose() async {
    return _expencesController.close();
  }
}
