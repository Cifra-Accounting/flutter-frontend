import 'dart:async';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group("CategoryRepository", () {
    Database? db;
    CategoryRepository? categoryRepository;
    StreamSubscription<List<Category>>? categorySubscription;

    setUp(() async {
      db = await testInitialize();

      categoryRepository = CategoryRepository(db: db!);
    });

    test("save", () async {
      Category category = Category()
        ..name.value = 'Category 1'
        ..icon.value = 1;

      category = await categoryRepository!.save(category);

      expect(category.id.value, 1, reason: "category id");

      categorySubscription =
          categoryRepository!.onCategories.listen((List<Category> categories) {
        expect(categories.length, 1, reason: "categories length");
        expect(categories.first.id.value, category.id.value,
            reason: "category id");
        expect(categories.first.name.value, category.name.value,
            reason: "category name");
        expect(categories.first.icon.value, category.icon.value,
            reason: "category icon");
      });
    });

    test("saveAll", () async {
      final List<Category> categories = [
        Category()
          ..name.value = 'Category 1'
          ..icon.value = 1,
        Category()
          ..name.value = 'Category 2'
          ..icon.value = 2,
      ];

      final List<Category> savedCategories =
          await categoryRepository!.saveAll(categories);

      expect(savedCategories.length, 2, reason: "categories length");

      categorySubscription =
          categoryRepository!.onCategories.listen((List<Category> categories) {
        expect(categories.length, 2, reason: "categories length");

        for (int i = 0; i < categories.length; i++) {
          expect(categories[i].id.value, isNotNull, reason: "category id");
          expect(categories[i].name.value, savedCategories[i].name.value,
              reason: "category name");
          expect(categories[i].icon.value, savedCategories[i].icon.value,
              reason: "category icon");
        }
      });
    });

    test("getById", () async {
      final List<Category> categories = [
        Category()
          ..name.value = 'Category 1'
          ..icon.value = 1,
        Category()
          ..name.value = 'Category 2'
          ..icon.value = 2,
      ];

      final List<Category> savedCategories =
          await categoryRepository!.saveAll(categories);

      final Category? category =
          await categoryRepository!.getById(savedCategories.last.id.value!);

      expect(category!.id.value, savedCategories.last.id.value, reason: "id");
      expect(category.name.value, savedCategories.last.name.value,
          reason: "name");
      expect(category.icon.value, savedCategories.last.icon.value,
          reason: "icon");
    });

    test("getList", () async {
      final List<Category> categories = [
        Category()
          ..name.value = 'Category 1'
          ..icon.value = 1,
        Category()
          ..name.value = 'Category 2'
          ..icon.value = 2,
      ];

      final List<Category> savedCategories =
          await categoryRepository!.saveAll(categories);

      final List<Category> loadedCategories =
          await categoryRepository!.getList();

      expect(loadedCategories.length, 2, reason: "categories length");

      for (int i = 0; i < loadedCategories.length; i++) {
        expect(loadedCategories[i].id.value, savedCategories[i].id.value,
            reason: "category id");
        expect(loadedCategories[i].name.value, savedCategories[i].name.value,
            reason: "category name");
        expect(loadedCategories[i].icon.value, savedCategories[i].icon.value,
            reason: "category icon");
      }
    });

    test("delete", () async {
      final List<Category> categories = [
        Category()
          ..name.value = 'Category 1'
          ..icon.value = 1,
        Category()
          ..name.value = 'Category 2'
          ..icon.value = 2,
      ];

      final List<Category> savedCategories =
          await categoryRepository!.saveAll(categories);

      final int deleted =
          await categoryRepository!.delete(savedCategories.last.id.value!);

      expect(deleted, 1, reason: "deleted");

      final List<Category> loadedCategories =
          await categoryRepository!.getList();

      expect(loadedCategories.length, 1, reason: "categories length");
      expect(loadedCategories.first.id.value, savedCategories.first.id.value,
          reason: "category id");
      expect(
          loadedCategories.first.name.value, savedCategories.first.name.value,
          reason: "category name");
      expect(
          loadedCategories.first.icon.value, savedCategories.first.icon.value,
          reason: "category icon");
    });

    tearDown(() async {
      await categorySubscription?.cancel();
      await categoryRepository?.dispose();

      await db?.close();
    });
  });
}
