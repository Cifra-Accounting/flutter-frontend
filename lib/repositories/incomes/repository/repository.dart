import 'dart:async';
import 'package:cifra_app/repositories/repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/incomes/models/income.dart';

class CategoryNotFoundException implements Exception {
  final String message;
  CategoryNotFoundException(this.message);
  @override
  String toString() => message;
}

class IncomeRepository implements Repository<Income> {
  IncomeRepository({required this.db});

  final Database db;

  final List<Income> _value = <Income>[];
  final Map<String, int> _categoryCache = {};

  bool _loadedAll = false;

  FutureOr<int> _getCategoryId(String categoryName, int categoryIcon) async {
    final cacheKey = '$categoryName-$categoryIcon';
    if (_categoryCache.containsKey(cacheKey)) {
      return _categoryCache[cacheKey]!;
    }

    final List<Map<String, dynamic>> categoryResponse = await db.rawQuery(
      """
      SELECT id FROM Categories WHERE name = ? AND icon = ?;
      """,
      [categoryName, categoryIcon],
    );

    if (categoryResponse.isEmpty) {
      throw Exception("Category not found");
    }

    final int categoryId = categoryResponse.first["id"] as int;
    _categoryCache[cacheKey] = categoryId;
    return categoryId;
  }

  @override
  Future<List<Income>> getAll() async {
    if (!_loadedAll) {
      final List<Map<String, dynamic>> response = await db.rawQuery(
        """
    SELECT 
      i.title AS title, 
      i.amount AS amount, 
      i.date AS date, 
      i.description AS description, 
      c.name AS name, 
      c.icon AS icon
    FROM 
      Incomes AS i
      JOIN Categories AS c 
        ON c.id = i.category_id
    ORDER BY date;
    """,
      );

      final List<Income> result = response
          .map<Income>(
            (Map<String, dynamic> json) => Income.fromJson(json),
          )
          .toList();

      _value.addAll(result);
    }
    _loadedAll = true;

    return _value;
  }

  @override

  /// Will return empty list if  page is out of bounds
  FutureOr<List<Income>> getPage(int offset, int limit) async {
    if ((_value.isEmpty || offset + limit > _value.length) && !_loadedAll) {
      final List<Map<String, dynamic>> response = await db.rawQuery(
        """
        SELECT 
          i.title AS title, 
          i.amount AS amount, 
          i.date AS date, 
          i.description AS description, 
          c.name AS name, 
          c.icon AS icon
        FROM 
          Incomes AS i
          JOIN Categories AS c 
            ON c.id = i.category_id
        ORDER BY date
        LIMIT ?, ?;
        """,
        [offset, limit],
      );

      final List<Income> result = response
          .map<Income>(
            (Map<String, dynamic> json) => Income.fromJson(json),
          )
          .toList();

      _value.addAll(result);
    }

    final List<Income> result = <Income>[];

    for (int i = offset; i < offset + limit; i++) {
      final Income? atIndex = _value.elementAtOrNull(i);

      if (atIndex != null) {
        result.add(atIndex);
      } else {
        _loadedAll = true;
        break;
      }
    }

    return result;
  }

  @override

  /// Will return null if index out of bounds
  FutureOr<Income?> getAt(int index) async {
    if ((_value.isEmpty || index >= _value.length) && !_loadedAll) {
      final List<Map<String, dynamic>> response = await db.rawQuery(
        """
        SELECT 
          i.title AS title, 
          i.amount AS amount, 
          i.date AS date, 
          i.description AS description, 
          c.name AS name, 
          c.icon AS icon
        FROM 
          Incomes AS i
          JOIN Categories AS c 
            ON c.id = i.category_id
        ORDER BY date
        LIMIT ?, ?;
        """,
        [_value.length, _value.length + index],
      );

      final List<Income> result = response
          .map<Income>(
            (Map<String, dynamic> json) => Income.fromJson(json),
          )
          .toList();

      _value.addAll(result);
    }

    final Income? result = _value.elementAtOrNull(index);

    if (result == null) {
      _loadedAll = true;
    }

    return result;
  }

  @override

  /// Will throw is the newValue has nonexistant category
  Future<void> put(Income newValue) async {
    final int categoryId =
        await _getCategoryId(newValue.category.name, newValue.category.icon);

    _value.add(newValue);

    await db.insert(
      "Incomes",
      newValue.toJson(categoryId: categoryId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override

  /// Will throw if couldn't execute batch, will check whether category_id is existant
  Future<void> putAll(List<Income> newValue) async {
    final Batch batch = db.batch();

    for (final Income income in newValue) {
      late final int categoryId;

      try {
        categoryId =
            await _getCategoryId(income.category.name, income.category.icon);
      } catch (e) {
        continue;
      }

      _value.add(income);

      batch.insert(
        "Incomes",
        income.toJson(categoryId: categoryId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    try {
      await batch.commit(noResult: true);
    } catch (e) {
      throw Exception("Failed to insert incomes in batch.");
    }
  }

  @override
  Future<void> delete(int index) async {
    final int? idToRemove = _value.elementAtOrNull(index)?.id;

    if (idToRemove == null) return;

    _value.removeAt(index);
    await db.rawDelete(
      """
      DELETE FROM Incomes WHERE id = ?
      """,
      [idToRemove],
    );
  }

  @override

  /// Will throw if new category doesn't exist
  Future<void> update(int index, Income newValue) async {
    final int? idToRemove = _value.elementAtOrNull(index)?.id;

    if (idToRemove == null) return;

    final List<Map<String, dynamic>> categoryResponse = await db.rawQuery(
      """
        SELECT 
          id 
        FROM 
          Categories 
        WHERE 
          name = ? 
          AND icon = ?;
        """,
      [newValue.category.name, newValue.category.icon],
    );

    if (categoryResponse.isEmpty) {
      throw Exception("Category not found");
    }

    final int categoryId = categoryResponse.first["id"] as int;
    _value[index] = newValue;

    await db.rawUpdate(
      """
      UPDATE Incomes SET category_id = ?, title = ?, amount = ?, date = ?, description = ?
      WHERE id = ?
    """,
      [
        categoryId,
        newValue.title,
        newValue.amount,
        newValue.date,
        newValue.description,
        newValue.id,
      ],
    );
  }
}
