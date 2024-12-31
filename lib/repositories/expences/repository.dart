import 'dart:async';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/expences/models/expence.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';
import 'package:cv/cv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    final List<Expence> expences =
        await getList(offset: 0, limit: 20, desc: _isDesc);
    _cache.clear();

    for (final Expence expence in expences) {
      _cache[expence.id.value!] = expence;
    }

    _expencesController.sink.add(expences);
  }

  @override
  FutureOr<Expence?> getById(int id) async {
    final Expence? result = _cache[id];
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
    return Expence()..fromMap(list.first);
  }

  @override
  Future<List<Expence>> getList({
    int? offset,
    int? limit,
    bool desc = false,
  }) async {
    if (_isDesc != desc) {
      _cache.clear();
      _isDesc = desc;
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

    final List<Expence> expences = results.cv<Expence>();

    for (final Expence expence in expences) {
      _cache[expence.id.value!] = expence;
    }

    _expencesController.sink.add(
      _cache.sortedValues(desc: _isDesc),
    );

    return expences;
  }

  @override
  Future<void> save(Expence expence) async {
    try {
      if (expence.id.value == null) {
        await db.insert(tableName, expence.toMap());
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
    } catch (e) {
      throw RepositoryException('Failed to save income: $e', runtimeType);
    }
  }

  @override
  Future<void> saveAll(List<Expence> expences) async {
    final Batch batch = db.batch();

    try {
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

      await batch.commit(noResult: true);

      for (final Expence expence in expences) {
        if (_cache.containsKey(expence.id.value)) {
          _cache[expence.id.value!] = expence;
        } else {
          return await _updateCached();
        }
      }

      _expencesController.sink.add(
        _cache.sortedValues(desc: _isDesc),
      );
    } catch (e) {
      throw RepositoryException(
          "Failed to save all the incomes: $e", runtimeType);
    }
  }

  @override
  Future delete(int id) async {
    await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
    if (_cache.containsKey(id)) {
      _cache.remove(id);
      _expencesController.sink.add(
        _cache.sortedValues(desc: _isDesc),
      );
    } else {
      await _updateCached();
    }
  }

  void dispose() {
    _expencesController.close();
  }
}
