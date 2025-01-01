import 'dart:async';

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

    test('delete', () async {
      final Income income = await incomeRepository!.save(
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..amount.value = 100.0
          ..date.value = DateTime.now(),
      );

      final int deleted = await incomeRepository!.delete(income.id.value!);

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
