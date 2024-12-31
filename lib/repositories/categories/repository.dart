import 'dart:async';

import 'package:cv/cv.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/models/repository.dart';
import 'package:cifra_app/repositories/utils/repository_exception.dart';

class CategoryRepository extends Repository<Category> {
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
  final Set<Category> _cache = <Category>{};

  late final StreamController<List<Category>> _categoriesController =
      StreamController<List<Category>>.broadcast(
    onListen: () => _categoriesController.sink.add(_cache.toList()),
  );

  Stream<List<Category>> get onCategories => _categoriesController.stream;

  @override
  FutureOr<Category?> getById(int id) async {
    try {
      final Category toGet = _cache.firstWhere(
          (element) => element.id.value == id,
          orElse: () => Category());
      if (toGet.id.value != null) {
        return toGet;
      }

      final List<Map<String, Object?>> list = await db.rawQuery('''
  SELECT 
    $idColumn,
      $categoryNameColumn,
      $categoryIconColumn
    FROM $tableName
    WHERE $idColumn = ?
    ''');

      if (list.isEmpty) {
        return null;
      }
      return Category()..fromMap(list.first);
    } catch (e) {
      throw RepositoryException("Failed to get category: $e", runtimeType);
    }
  }

  @override
  FutureOr<List<Category>> getList(
      {int? offset, int? limit, bool desc = false}) async {
    try {
      if (_cache.isNotEmpty) {
        _categoriesController.sink.add(_cache.toList());
        return _cache.toList();
      }

      const String querry = '''
      SELECT 
        $idColumn,
        $categoryNameColumn,
        $categoryIconColumn
      FROM $tableName
      ''';

      final List<Map<String, Object?>> list = await db.rawQuery(querry);

      final List<Category> categories = list.cv<Category>();

      _cache.addAll(categories);

      _categoriesController.sink.add(_cache.toList());

      return categories;
    } catch (e) {
      _categoriesController.addError(
        RepositoryException("Failed to get categories: $e", runtimeType),
      );
      return <Category>[];
    }
  }

  @override
  Future<void> save(Category value) async {
    try {
      if (value.id.value == null) {
        final int id = await db.insert(tableName, value.toMap());
        value.id.value = id;
        _cache.add(value);
      } else {
        db.update(tableName, value.toMap(),
            where: '$idColumn = ?', whereArgs: [value.id.value]);
        _cache.removeWhere(
            (Category categeory) => categeory.id.value == value.id.value);
        _cache.add(value);
      }

      _categoriesController.sink.add(_cache.toList());
    } catch (e) {
      _categoriesController.addError(
        RepositoryException("Failed to save category: $e", runtimeType),
      );
    }
  }

  @override
  Future<void> saveAll(List<Category> values) async {
    final Batch batch = db.batch();

    try {
      for (final Category category in values) {
        if (category.id.value == null) {
          batch.insert(tableName, category.toMap());
        } else {
          batch.update(tableName, category.toMap(),
              where: '$idColumn = ?', whereArgs: [category.id.value]);
        }
      }

      final List<Object?> ids = await batch.commit(noResult: true);

      int index = 0;
      for (final Category category in values) {
        if (category.id.value == null) {
          category.id.value = ids[index++] as int;
          _cache.add(category);
        } else {
          _cache.removeWhere(
              (Category categeory) => categeory.id.value == category.id.value);
          _cache.add(category);
        }
      }

      _categoriesController.sink.add(_cache.toList());
    } catch (e) {
      _categoriesController.addError(
        RepositoryException(
            "Failed to save all the categories: $e", runtimeType),
      );
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
      _cache.removeWhere((element) => element.id.value == id);
      _categoriesController.sink.add(_cache.toList());
    } catch (e) {
      _categoriesController.addError(
        RepositoryException("Failed to delete category: $e", runtimeType),
      );
    }
  }

  void dispose() {
    _categoriesController.close();
  }
}