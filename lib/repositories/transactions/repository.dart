import 'dart:async';

import 'package:cv/cv.dart';
import 'package:sqflite/sqflite.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/common/models/get_filter.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart'
    as models;

import 'package:cifra_app/repositories/utils/db_constants.dart';
import 'package:cifra_app/repositories/models/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';

class TransactionRepository implements Repository<models.Transaction> {
  static const String tableName = "transacions";
  static const String createQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
      $categoryIdColumn INTEGER NOT NULL,
      $titleColumn TEXT NOT NULL,
      $amountColumn INTEGER NOT NULL,
      $typeColumn TEXT NOT NULL,
      $currencyColumn TEXT NOT NULL,
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
    CREATE INDEX IF NOT EXISTS ${tableName}_type_idx
    ON $tableName ($typeColumn);
  ''';

  TransactionRepository({required this.db});

  final Database db;

  late final StreamController<bool> _updateController =
      StreamController<bool>.broadcast();

  Stream<bool> get shouldUpdateTransactions => _updateController.stream;

  Map<String, dynamic> _parseMap(Map<String, dynamic> map) {
    final Map<String, dynamic> newMap = <String, dynamic>{};

    for (final MapEntry<String, dynamic> entry in map.entries) {
      switch (entry.key) {
        case categoryIdColumn:
          newMap[categoryIdColumn] = <String, dynamic>{
            idColumn: map[categoryIdColumn],
            categoryNameColumn: map[categoryNameColumn] as String,
            categoryIconColumn: map[categoryIconColumn],
          };
          break;
        case amountColumn:
          newMap[amountColumn] = <String, dynamic>{
            amountColumn: map[amountColumn],
            currencyColumn: map[currencyColumn] as String,
          };
          break;
        default:
          newMap[entry.key] = entry.value;
      }
    }

    return newMap;
  }

  @override
  Future<models.Transaction?> getById(int id) async {
    try {
      const String querry = '''
        SELECT
          i.$idColumn as $idColumn,
          i.$categoryIdColumn as $categoryIdColumn,
          c.$categoryNameColumn as $categoryNameColumn,
          c.$categoryIconColumn as $categoryIconColumn,
          i.$titleColumn as $titleColumn,
          i.$amountColumn as $amountColumn,
          i.$typeColumn as $typeColumn,
          i.$currencyColumn as $currencyColumn,
          i.$dateColumn as $dateColumn, 
          i.$descriptionColumn as $descriptionColumn
        FROM $tableName i
        JOIN ${CategoryRepository.tableName} c ON i.$categoryIdColumn = c.$idColumn
        WHERE i.$idColumn = ?
        ''';
      final List<Object> args = [id];

      final List<Map<String, Object?>> results =
          await db.rawQuery(querry, args);

      return models.Transaction()..fromMap(results.map(_parseMap).single);
    } catch (e) {
      _updateController.addError(
        RepositoryException("Failed to get transaction: $e", runtimeType),
      );
      return null;
    }
  }

  @override
  Future<List<models.Transaction>> getList({
    int? offset,
    int? limit,
    bool desc = false,
    GetFilter? filter,
  }) async {
    try {
      final String orderBy = '$dateColumn ${desc ? 'DESC' : 'ASC'}';
      final String limitOffset =
          (limit == null || offset == null) ? '' : 'LIMIT ? OFFSET ?';
      final String where = (filter == null) ? '' : filter.where;
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
        i.$typeColumn as $typeColumn,
        i.$currencyColumn as $currencyColumn,
        i.$dateColumn as $dateColumn,
        i.$descriptionColumn as $descriptionColumn
      FROM $tableName i
      JOIN ${CategoryRepository.tableName} c ON i.$categoryIdColumn = c.$idColumn
      $where
      ORDER BY $orderBy
      $limitOffset
      ''';

      final List<Map<String, dynamic>> results =
          await db.rawQuery(query, [...?(filter?.whereArgs), ...args]);

      final List<models.Transaction> transacions =
          results.map(_parseMap).toList().cv<models.Transaction>();

      return transacions;
    } catch (e) {
      _updateController.addError(
        RepositoryException("Failed to get transacions: $e", runtimeType),
      );
      return <models.Transaction>[];
    }
  }

  @override
  Future<models.Transaction> save(models.Transaction transaction) async {
    try {
      if (transaction.id.value == null) {
        final int id = await db.insert(tableName, transaction.toMap());
        transaction.id.value = id;
      } else {
        await db.update(
          tableName,
          transaction.toMap(),
          where: '$idColumn = ?',
          whereArgs: [transaction.id.value],
        );
      }

      _notifyListeners();

      return transaction;
    } catch (e) {
      _updateController.addError(
          RepositoryException('Failed to save income: $e', runtimeType));
      return models.Transaction();
    }
  }

  @override
  Future<List<models.Transaction>> saveAll(
      List<models.Transaction> transacions) async {
    try {
      final Batch batch = db.batch();

      for (final models.Transaction transaction in transacions) {
        if (transaction.id.value == null) {
          batch.insert(tableName, transaction.toMap());
        } else {
          batch.update(
            tableName,
            transaction.toMap(),
            where: '$idColumn = ?',
            whereArgs: [transaction.id.value],
          );
        }
      }

      final List<Object?> result = await batch.commit();

      for (int index = 0; index < transacions.length; index++) {
        final models.Transaction transaction = transacions[index];
        final int? resultItem = result[index] as int?;

        transaction.id.value ??= resultItem;
      }

      _notifyListeners();

      return transacions;
    } catch (e) {
      _updateController.addError(RepositoryException(
          "Failed to save all the incomes: $e", runtimeType));
      return <models.Transaction>[];
    }
  }

  @override
  Future<int> delete(models.Transaction transaction) async {
    try {
      final int result = await db.delete(
        tableName,
        where: '$idColumn = ?',
        whereArgs: [transaction.id.value],
      );

      _notifyListeners();

      return result;
    } catch (e) {
      _updateController.addError(
        RepositoryException("Failed to delete transaction: $e", runtimeType),
      );
      return 0;
    }
  }

  Future dispose() async => _updateController.close();

  void _notifyListeners() {
    _updateController.sink.add(true);
  }
}
