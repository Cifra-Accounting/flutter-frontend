import 'dart:async';

import 'package:cifra_app/repositories/utils/db_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/expences/models/expence.dart';
import 'package:cifra_app/repositories/expences/repository.dart';

void main() {
  group('ExpenceRepository', () {
    Database? db;
    CategoryRepository? categoryRepository;
    ExpenceRepository? expenceRepository;
    StreamSubscription<List<Expence>>? expenceSubscription;

    Category? category1;
    Category? category2;

    Future<void> setUpCategories() async {
      category1 = await categoryRepository!.save(
        Category()
          ..name.value = 'Category 1'
          ..icon.value = 1,
      );
      category2 = await categoryRepository!.save(
        Category()
          ..name.value = 'Category 2'
          ..icon.value = 2,
      );
    }

    setUp(() async {
      db = await testInitialize();

      categoryRepository = CategoryRepository(db: db!);
      expenceRepository = ExpenceRepository(db: db!);

      await setUpCategories();
    });

    test('save', () async {
      final Expence expence = await expenceRepository!.save(
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
      );

      expect(expence.id.value, isNotNull);

      expenceSubscription = expenceRepository!.onExpences.listen(
        (incomes) {
          expect(incomes.length, 1);

          expect(incomes.first.id.value, isNotNull);
          expect(incomes.first.category.value, category1);
          expect(incomes.first.title.value, 'Expence 1');
          expect(incomes.first.amount.value, 100.0);
          expect(incomes.first.date.value, isNotNull);
        },
      );
    });

    test('saveAll', () async {
      final List<Expence> incomes = await expenceRepository!.saveAll([
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now(),
      ]);

      expect(incomes.length, 2);

      expect(incomes.length, 2);

      expect(incomes.first.id.value, isNotNull);
      expect(incomes.first.category.value, category1);
      expect(incomes.first.title.value, 'Expence 1');
      expect(incomes.first.amount.value, 100.0);
      expect(incomes.first.date.value, isNotNull);

      expect(incomes.last.id.value, isNotNull);
      expect(incomes.last.category.value, category2);
      expect(incomes.last.title.value, 'Expence 2');
      expect(incomes.last.amount.value, 200.0);
      expect(incomes.last.date.value, isNotNull);

      expenceSubscription = expenceRepository!.onExpences.listen((incomes) {
        expect(incomes.length, 2);

        expect(incomes.first.id.value, isNotNull);
        expect(incomes.first.category.value, category1);
        expect(incomes.first.title.value, 'Expence 1');
        expect(incomes.first.amount.value, 100.0);
        expect(incomes.first.date.value, isNotNull);

        expect(incomes.last.id.value, isNotNull);
        expect(incomes.last.category.value, category2);
        expect(incomes.last.title.value, 'Expence 2');
        expect(incomes.last.amount.value, 200.0);
        expect(incomes.last.date.value, isNotNull);
      });
    });

    test('saveAll and update ', () async {
      List<Expence> incomes = <Expence>[
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 3'
          ..amount.value = 400.0
          ..date.value = DateTime.now(),
      ];

      incomes[0] = await expenceRepository!.save(incomes[0]);
      incomes[2] = await expenceRepository!.save(incomes[2]);

      incomes[0].amount.value = 200.0;
      incomes[2].amount.value = 800.0;

      final List<Expence> result = await expenceRepository!.saveAll(incomes);

      expect(result.length, 3, reason: 'saveAll and update result list length');

      expect(result[0].id.value, incomes[0].id.value);
      expect(result[0].category.value, category1);
      expect(result[0].title.value, 'Expence 1');
      expect(result[0].amount.value, 200.0);
      expect(result[0].date.value, isNotNull);

      expect(result[1].id.value, 3);
      expect(result[1].category.value, category2);
      expect(result[1].title.value, 'Expence 2');
      expect(result[1].amount.value, 200.0);
      expect(result[1].date.value, isNotNull);

      expect(result[2].id.value, incomes[2].id.value);
      expect(result[2].category.value, category1);
      expect(result[2].title.value, 'Expence 3');
      expect(result[2].amount.value, 800.0);
      expect(result[2].date.value, isNotNull);
      expect(result.last.id.value, isNotNull);

      expenceSubscription = expenceRepository!.onExpences.listen((newIncomes) {
        expect(newIncomes.length, incomes.length);
      });
    });

    test("sumByTime", () async {
      final List<Expence> incomes = <Expence>[
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 3'
          ..amount.value = 400.0
          ..date.value = DateTime.now(),
      ];

      await expenceRepository!.saveAll(incomes);

      final double result = await expenceRepository!.sumByTime(
        duration: Durations.medium1 + Durations.short1,
      );

      expect(result, 600.0);

      final double result2 = await expenceRepository!.sumByTime();

      expect(result2, 700.0);
    });

    test("sumByCategoryAndTime", () async {
      final List<Expence> incomes = <Expence>[
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 3'
          ..amount.value = 400.0
          ..date.value = DateTime.now(),
      ];

      await expenceRepository!.saveAll(incomes);

      final double result = await expenceRepository!.sumByCategoryAndTime(
        category: category1,
      );

      expect(result, 500.0);

      final double result2 = await expenceRepository!.sumByCategoryAndTime(
        category: category1,
        duration: Durations.medium1 + Durations.short1,
      );

      expect(result2, 400.0);
    });

    test('getById', () async {
      final Expence expence = await expenceRepository!.save(
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
      );

      final Expence? incomeById =
          await expenceRepository!.getById(expence.id.value!);

      expect(incomeById, isNotNull);
      expect(incomeById!.id.value, expence.id.value);
      expect(incomeById.category.value, category1);
      expect(incomeById.title.value, 'Expence 1');
    });

    test('getList', () async {
      final List<Expence> incomes = await expenceRepository!.getList();

      expect(incomes, isEmpty);

      await expenceRepository!.saveAll([
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now(),
      ]);

      final List<Expence> incomesList = await expenceRepository!.getList();

      expect(incomesList.length, 2);
    });

    test('getList paginated', () async {
      final List<Expence> incomes = await expenceRepository!.saveAll([
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 3'
          ..amount.value = 300.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 4'
          ..amount.value = 400.0
          ..date.value = DateTime.now().subtract(Durations.medium3),
      ]);

      List<Expence> result =
          await expenceRepository!.getList(offset: 1, limit: 2, desc: true);

      expect(result.first.id.value, incomes[1].id.value);
      expect(result.last.id.value, incomes[2].id.value);

      result = await expenceRepository!.getList(offset: 1, limit: 2);

      expect(result.first.id.value, incomes[2].id.value);
      expect(result.last.id.value, incomes[1].id.value);
    });

    test('delete', () async {
      final Expence expence = await expenceRepository!.save(
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
      );

      final int deleted = await expenceRepository!.delete(expence.id.value!);

      expect(deleted, 1);

      final List<Expence> incomes = await expenceRepository!.getList();

      expect(incomes, isEmpty);
    });

    tearDown(() async {
      await expenceSubscription?.cancel();

      await expenceRepository?.dispose();
      await categoryRepository?.dispose();

      await db?.close();
    });
  });
}
