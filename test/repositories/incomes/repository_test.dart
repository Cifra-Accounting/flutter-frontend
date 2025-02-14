import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/models/money.dart';
import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/incomes/models/income.dart';
import 'package:cifra_app/repositories/incomes/repository.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';

void main() {
  group('IncomeRepository', () {
    Database? db;
    CategoryRepository? categoryRepository;
    IncomeRepository? expenceRepository;
    StreamSubscription<List<Income>>? expenceSubscription;

    Category? category1;
    Category? category2;

    Money? transaction1;
    Money? transaction2;
    Money? transaction3;

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

    void setUpTransactions() {
      transaction1 = const Money(
        currency: Currency.usd,
        amountInSmallestUnits: 10000,
      );
      transaction2 = const Money(
        currency: Currency.eur,
        amountInSmallestUnits: 100000,
      );
      transaction3 = const Money(
        currency: Currency.rub,
        amountInSmallestUnits: 10000000,
      );
    }

    setUp(() async {
      db = await testInitialize();

      categoryRepository = CategoryRepository(db: db!);
      expenceRepository = IncomeRepository(db: db!);

      await setUpCategories();
      setUpTransactions();
    });

    test('save', () async {
      final Income income = await expenceRepository!.save(
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
      );

      expect(income.id.value, isNotNull, reason: 'Income id is not null');

      expenceSubscription = expenceRepository!.onIncomes.listen(
        (income) {
          expect(income.length, 1, reason: 'Expences length');
          expect(income.first.id.value, isNotNull, reason: 'Income id');
          expect(income.first.category.value, category1, reason: 'Category 1');
          expect(income.first.title.value, 'Income 1', reason: 'Income 1');
          expect(income.first.transaction.value, transaction1,
              reason: 'Transaction 1');
          expect(income.first.date.value, isNotNull,
              reason: 'Date is not null');
        },
      );
    });

    test('saveAll', () async {
      final List<Income> income = await expenceRepository!.saveAll([
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..transaction.value = transaction2
          ..date.value = DateTime.now(),
      ]);

      expect(income.length, 2);

      expect(income.length, 2);

      expect(income.first.id.value, isNotNull);
      expect(income.first.category.value, category1);
      expect(income.first.title.value, 'Income 1');
      expect(income.first.transaction.value, transaction1);
      expect(income.first.date.value, isNotNull);

      expect(income.last.id.value, isNotNull);
      expect(income.last.category.value, category2);
      expect(income.last.title.value, 'Income 2');
      expect(income.last.transaction.value, transaction2);
      expect(income.last.date.value, isNotNull);

      expenceSubscription = expenceRepository!.onIncomes.listen((income) {
        expect(income.length, 2);

        expect(income.first.id.value, isNotNull);
        expect(income.first.category.value, category1);
        expect(income.first.title.value, 'Income 1');
        expect(income.first.transaction.value, transaction1);
        expect(income.first.date.value, isNotNull);

        expect(income.last.id.value, isNotNull);
        expect(income.last.category.value, category2);
        expect(income.last.title.value, 'Income 2');
        expect(income.last.transaction.value, transaction2);
        expect(income.last.date.value, isNotNull);
      });
    });

    test('saveAll and update ', () async {
      List<Income> income = <Income>[
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..transaction.value = transaction2
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Income()
          ..category.value = category1
          ..title.value = 'Income 3'
          ..transaction.value = transaction3
          ..date.value = DateTime.now(),
      ];

      income[0] = await expenceRepository!.save(income[0]);
      income[2] = await expenceRepository!.save(income[2]);

      income[0].transaction.value = transaction1!.copyWith(
        amountInSmallestUnits: 20000,
      );
      income[2].transaction.value = transaction3!.copyWith(
        amountInSmallestUnits: 800000,
      );

      final List<Income> result = await expenceRepository!.saveAll(income);

      expect(result.length, 3, reason: 'saveAll and update result list length');

      expect(result[0].id.value, income[0].id.value);
      expect(result[0].category.value, category1);
      expect(result[0].title.value, 'Income 1');
      expect(result[0].transaction.value, income[0].transaction.value);
      expect(result[0].date.value, isNotNull);

      expect(result[1].id.value, 3);
      expect(result[1].category.value, category2);
      expect(result[1].title.value, 'Income 2');
      expect(result[1].transaction.value, income[1].transaction.value);
      expect(result[1].date.value, isNotNull);

      expect(result[2].id.value, income[2].id.value);
      expect(result[2].category.value, category1);
      expect(result[2].title.value, 'Income 3');
      expect(result[2].transaction.value, income[2].transaction.value);
      expect(result[2].date.value, isNotNull);
      expect(result.last.id.value, isNotNull);

      expenceSubscription = expenceRepository!.onIncomes.listen((newIncomes) {
        expect(newIncomes.length, income.length);
      });
    });

    test('getById', () async {
      final Income income = await expenceRepository!.save(
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
      );

      final Income? expenceById =
          await expenceRepository!.getById(income.id.value!);

      expect(expenceById, isNotNull);
      expect(expenceById!.id.value, income.id.value);
      expect(expenceById.category.value, category1);
      expect(expenceById.title.value, 'Income 1');
      expect(expenceById.transaction.value, transaction1);
      expect(expenceById.date.value, isNotNull);
    });

    test('getList', () async {
      final List<Income> incomes = await expenceRepository!.getList();

      expect(incomes, isEmpty);

      await expenceRepository!.saveAll([
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..transaction.value = transaction2
          ..date.value = DateTime.now(),
      ]);

      final List<Income> incomesList = await expenceRepository!.getList();

      expect(incomesList.length, 2);
    });

    test('getList paginated', () async {
      final List<Income> incomes = await expenceRepository!.saveAll([
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
        Income()
          ..category.value = category2
          ..title.value = 'Income 2'
          ..transaction.value = transaction2
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Income()
          ..category.value = category1
          ..title.value = 'Income 3'
          ..transaction.value = transaction3
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Income()
          ..category.value = category2
          ..title.value = 'Income 4'
          ..transaction.value = transaction2
          ..date.value = DateTime.now().subtract(Durations.medium3),
      ]);

      List<Income> result =
          await expenceRepository!.getList(offset: 1, limit: 2, desc: true);

      expect(result.first.id.value, incomes[1].id.value);
      expect(result.last.id.value, incomes[2].id.value);

      result = await expenceRepository!.getList(offset: 1, limit: 2);

      expect(result.first.id.value, incomes[2].id.value);
      expect(result.last.id.value, incomes[1].id.value);
    });

    test('delete', () async {
      final Income income = await expenceRepository!.save(
        Income()
          ..category.value = category1
          ..title.value = 'Income 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
      );

      final int deleted = await expenceRepository!.delete(income);

      expect(deleted, 1);

      final List<Income> incomes = await expenceRepository!.getList();

      expect(incomes, isEmpty);
    });

    tearDown(() async {
      await expenceSubscription?.cancel();

      await expenceRepository?.dispose();
      await categoryRepository?.dispose();

      await db?.close();

      transaction1 = null;
      transaction2 = null;
      transaction3 = null;
    });
  });
}
