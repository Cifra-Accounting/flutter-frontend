import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/incomes/models/income.dart';
import 'package:cifra_app/repositories/incomes/repository.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';

void main() {
  group('IncomeRepository', () {
    Database? db;
    CategoryRepository? categoryRepository;
    IncomeRepository? incomeRepository;
    StreamSubscription<List<Income>>? incomeSubscription;

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
      incomeRepository = IncomeRepository(db: db!);

      await setUpCategories();
    });

    test('save', () async {
      final Income income = await incomeRepository!.save(
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
      );

      expect(income.id.value, isNotNull);

      incomeSubscription = incomeRepository!.onIncomes.listen(
        (incomes) {
          expect(incomes.length, 1);

          expect(incomes.first.id.value, isNotNull);
          expect(incomes.first.category.value, category1);
          expect(incomes.first.title.value, 'Income 1');
          expect(incomes.first.amount.value, 100.0);
          expect(incomes.first.date.value, isNotNull);
        },
      );
    });

    test('saveAll', () async {
      final List<Income> incomes = await incomeRepository!.saveAll([
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now(),
      ]);

      expect(incomes.length, 2);

      expect(incomes.length, 2);

      expect(incomes.first.id.value, isNotNull);
      expect(incomes.first.category.value, category1);
      expect(incomes.first.title.value, 'Income 1');
      expect(incomes.first.amount.value, 100.0);
      expect(incomes.first.date.value, isNotNull);

      expect(incomes.last.id.value, isNotNull);
      expect(incomes.last.category.value, category2);
      expect(incomes.last.title.value, 'Income 2');
      expect(incomes.last.amount.value, 200.0);
      expect(incomes.last.date.value, isNotNull);

      incomeSubscription = incomeRepository!.onIncomes.listen((incomes) {
        expect(incomes.length, 2);

        expect(incomes.first.id.value, isNotNull);
        expect(incomes.first.category.value, category1);
        expect(incomes.first.title.value, 'Income 1');
        expect(incomes.first.amount.value, 100.0);
        expect(incomes.first.date.value, isNotNull);

        expect(incomes.last.id.value, isNotNull);
        expect(incomes.last.category.value, category2);
        expect(incomes.last.title.value, 'Income 2');
        expect(incomes.last.amount.value, 200.0);
        expect(incomes.last.date.value, isNotNull);
      });
    });

    test('saveAll and update ', () async {
      final List<Income> incomes = <Income>[
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Income()
          ..category.value = category1
          ..title.value = 'Income 3'
          ..amount.value = 400.0
          ..date.value = DateTime.now(),
      ];

      incomes[0] = await incomeRepository!.save(incomes[0]);
      incomes[2] = await incomeRepository!.save(incomes[2]);

      incomes[0].amount.value = 200.0;
      incomes[2].amount.value = 800.0;

      final List<Income> result = await incomeRepository!.saveAll(incomes);

      expect(result.length, 3, reason: 'saveAll and update result list length');

      expect(result[0].id.value, incomes[0].id.value);
      expect(result[0].category.value, category1);
      expect(result[0].title.value, 'Income 1');
      expect(result[0].amount.value, 200.0);
      expect(result[0].date.value, isNotNull);

      expect(result[1].id.value, 3);
      expect(result[1].category.value, category2);
      expect(result[1].title.value, 'Income 2');
      expect(result[1].amount.value, 200.0);
      expect(result[1].date.value, isNotNull);

      expect(result[2].id.value, incomes[2].id.value);
      expect(result[2].category.value, category1);
      expect(result[2].title.value, 'Income 3');
      expect(result[2].amount.value, 800.0);
      expect(result[2].date.value, isNotNull);
      expect(result.last.id.value, isNotNull);

      incomeSubscription = incomeRepository!.onIncomes.listen((newIncomes) {
        expect(newIncomes.length, incomes.length);
      });
    });

    test("sumByTime", () async {
      final List<Income> incomes = <Income>[
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Income()
          ..category.value = category1
          ..title.value = 'Income 3'
          ..amount.value = 400.0
          ..date.value = DateTime.now(),
      ];

      await incomeRepository!.saveAll(incomes);

      final double result = await incomeRepository!.sumByTime(
        duration: Durations.medium1 + Durations.short1,
      );

      expect(result, 600.0);

      final double result2 = await incomeRepository!.sumByTime();

      expect(result2, 700.0);
    });

    test("sumByCategoryAndTime", () async {
      final List<Income> incomes = <Income>[
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Income()
          ..category.value = category1
          ..title.value = 'Income 3'
          ..amount.value = 400.0
          ..date.value = DateTime.now(),
      ];

      await incomeRepository!.saveAll(incomes);

      final double result = await incomeRepository!.sumByCategoryAndTime(
        category: category1,
      );

      expect(result, 500.0);

      final double result2 = await incomeRepository!.sumByCategoryAndTime(
        category: category1,
        duration: Durations.medium1 + Durations.short1,
      );

      expect(result2, 400.0);
    });

    test('getById', () async {
      final Income income = await incomeRepository!.save(
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
      );

      final Income? incomeById =
          await incomeRepository!.getById(income.id.value!);

      expect(incomeById, isNotNull);
      expect(incomeById!.id.value, income.id.value);
      expect(incomeById.category.value, category1);
      expect(incomeById.title.value, 'Income 1');
    });

    test('getList', () async {
      final List<Income> incomes = await incomeRepository!.getList();

      expect(incomes, isEmpty);

      await incomeRepository!.saveAll([
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now(),
      ]);

      final List<Income> incomesList = await incomeRepository!.getList();

      expect(incomesList.length, 2);
    });

    test('getList paginated', () async {
      final List<Income> incomes = await incomeRepository!.saveAll([
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..amount.value = 200.0
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Income()
          ..category.value = category1
          ..title.value = 'Income 3'
          ..amount.value = 300.0
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Income()
          ..category.value = category2
          ..title.value = 'Income 4'
          ..amount.value = 400.0
          ..date.value = DateTime.now().subtract(Durations.medium3),
      ]);

      List<Income> result =
          await incomeRepository!.getList(offset: 1, limit: 2, desc: true);

      expect(result.first.id.value, incomes[1].id.value);
      expect(result.last.id.value, incomes[2].id.value);

      result = await incomeRepository!.getList(offset: 1, limit: 2);

      expect(result.first.id.value, incomes[2].id.value);
      expect(result.last.id.value, incomes[1].id.value);
    });

    test('delete', () async {
      final Income income = await incomeRepository!.save(
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
      );

      final int deleted = await incomeRepository!.delete(income);

      expect(deleted, 1);

      final List<Income> incomes = await incomeRepository!.getList();

      expect(incomes, isEmpty);
    });

    tearDown(() async {
      await incomeSubscription?.cancel();

      await incomeRepository?.dispose();
      await categoryRepository?.dispose();

      await db?.close();
    });
  });
}
