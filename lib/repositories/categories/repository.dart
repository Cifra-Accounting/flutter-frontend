import 'dart:async';

import 'package:cifra_app/common/models/get_filter.dart';
import 'package:cv/cv.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/utils/db_constants.dart';
import 'package:cifra_app/repositories/models/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';

class CategoryRepository implements Repository<Category> {
  static const String tableName = "categories";
  static const String createQuery = '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
      $categoryNameColumn TEXT NOT NULL,
      $categoryIconColumn INTEGER NOT NULL
    );
  ''';

  CategoryRepository({required this.db});

  final Database db;

  late final StreamController<bool> _updateController =
      StreamController<bool>.broadcast();

  Stream<bool> get shouldUpdateCategories => _updateController.stream;

  @override
  Future<Category?> getById(int id) async {
    try {
      final List<Map<String, Object?>> list = await db.query(
        tableName,
        where: '$idColumn = ?',
        whereArgs: [id],
      );

      if (list.isEmpty) {
        return null;
      }

      return Category()..fromMap(list.first);
    } catch (e) {
      _updateController.addError(
        RepositoryException("Failed to get category: $e", runtimeType),
      );
      return null;
    }
  }

  FutureOr<List<Category>> getAll() => getList();

  @override
  @protected
  FutureOr<List<Category>> getList({
    int? offset,
    int? limit,
    bool desc = false,
    GetFilter? filter,
  }) async {
    try {
      final List<Category> categories = (await db.query(
        tableName,
        where: filter?.where,
        whereArgs: filter?.whereArgs,
        limit: limit,
        offset: offset,
      ))
          .cv<Category>();

      return categories;
    } catch (e) {
      _updateController.addError(
        RepositoryException("Failed to get categories: $e", runtimeType),
      );
      return <Category>[];
    }
  }

  @override
  Future<Category> save(Category value) async {
    try {
      if (value.id.value == null) {
        value.id.value = await db.insert(
          tableName,
          value.toMap(),
        );
      } else {
        await db.update(
          tableName,
          value.toMap(),
          where: '$idColumn = ?',
          whereArgs: [value.id.value],
        );
      }

      _notifyListeners();

      return value;
    } catch (e) {
      _updateController.addError(
        RepositoryException("Failed to save category: $e", runtimeType),
      );
      return Category();
    }
  }

  @override
  Future<List<Category>> saveAll(List<Category> values) async {
    final Batch batch = db.batch();

    try {
      for (final Category category in values) {
        if (category.id.value == null) {
          batch.insert(
            tableName,
            category.toMap(),
          );
        } else {
          batch.update(
            tableName,
            category.toMap(),
            where: '$idColumn = ?',
            whereArgs: [category.id.value],
          );
        }
      }

      final List<Object?> result = await batch.commit();

      for (int index = 0; index < values.length; index++) {
        final Category category = values[index];
        final int? resultItem = result[index] as int?;

        category.id.value ??= resultItem;
      }

      _notifyListeners();

      return values;
    } catch (e) {
      _updateController.addError(
        RepositoryException(
          "Failed to save all the categories: $e",
          runtimeType,
        ),
      );
      return <Category>[];
    }
  }

  @override
  Future<int> delete(Category value) async {
    try {
      final int result = await db.delete(
        tableName,
        where: '$idColumn = ?',
        whereArgs: [value.id.value],
      );

      _notifyListeners();

      return result;
    } catch (e) {
      _updateController.addError(
        RepositoryException("Failed to delete category: $e", runtimeType),
      );
      return 0;
    }
  }

  Future dispose() async => _updateController.close();
  void _notifyListeners() => _updateController.sink.add(true);
}
