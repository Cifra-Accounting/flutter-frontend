import 'dart:async';

import 'package:cifra_app/repositories/models/money.dart';
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
      expenceRepository = ExpenceRepository(db: db!);

      await setUpCategories();
      setUpTransactions();
    });

    test('save', () async {
      final Expence expence = await expenceRepository!.save(
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
      );

      expect(expence.id.value, isNotNull, reason: 'Expence id is not null');

      expenceSubscription = expenceRepository!.onExpences.listen(
        (expences) {
          expect(expences.length, 1, reason: 'Expences length');
          expect(expences.first.id.value, isNotNull, reason: 'Expence id');
          expect(expences.first.category.value, category1,
              reason: 'Category 1');
          expect(expences.first.title.value, 'Expence 1', reason: 'Expence 1');
          expect(expences.first.transaction.value, transaction1,
              reason: 'Transaction 1');
          expect(expences.first.date.value, isNotNull,
              reason: 'Date is not null');
        },
      );
    });

    test('saveAll', () async {
      final List<Expence> expences = await expenceRepository!.saveAll([
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..transaction.value = transaction2
          ..date.value = DateTime.now(),
      ]);

      expect(expences.length, 2);

      expect(expences.length, 2);

      expect(expences.first.id.value, isNotNull);
      expect(expences.first.category.value, category1);
      expect(expences.first.title.value, 'Expence 1');
      expect(expences.first.transaction.value, transaction1);
      expect(expences.first.date.value, isNotNull);

      expect(expences.last.id.value, isNotNull);
      expect(expences.last.category.value, category2);
      expect(expences.last.title.value, 'Expence 2');
      expect(expences.last.transaction.value, transaction2);
      expect(expences.last.date.value, isNotNull);

      expenceSubscription = expenceRepository!.onExpences.listen((expences) {
        expect(expences.length, 2);

        expect(expences.first.id.value, isNotNull);
        expect(expences.first.category.value, category1);
        expect(expences.first.title.value, 'Expence 1');
        expect(expences.first.transaction.value, transaction1);
        expect(expences.first.date.value, isNotNull);

        expect(expences.last.id.value, isNotNull);
        expect(expences.last.category.value, category2);
        expect(expences.last.title.value, 'Expence 2');
        expect(expences.last.transaction.value, transaction2);
        expect(expences.last.date.value, isNotNull);
      });
    });

    test('saveAll and update ', () async {
      List<Expence> expences = <Expence>[
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..transaction.value = transaction2
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 3'
          ..transaction.value = transaction3
          ..date.value = DateTime.now(),
      ];

      expences[0] = await expenceRepository!.save(expences[0]);
      expences[2] = await expenceRepository!.save(expences[2]);

      expences[0].transaction.value = transaction1!.copyWith(
        amountInSmallestUnits: 20000,
      );
      expences[2].transaction.value = transaction3!.copyWith(
        amountInSmallestUnits: 800000,
      );

      final List<Expence> result = await expenceRepository!.saveAll(expences);

      expect(result.length, 3, reason: 'saveAll and update result list length');

      expect(result[0].id.value, expences[0].id.value);
      expect(result[0].category.value, category1);
      expect(result[0].title.value, 'Expence 1');
      expect(result[0].transaction.value, expences[0].transaction.value);
      expect(result[0].date.value, isNotNull);

      expect(result[1].id.value, 3);
      expect(result[1].category.value, category2);
      expect(result[1].title.value, 'Expence 2');
      expect(result[1].transaction.value, expences[1].transaction.value);
      expect(result[1].date.value, isNotNull);

      expect(result[2].id.value, expences[2].id.value);
      expect(result[2].category.value, category1);
      expect(result[2].title.value, 'Expence 3');
      expect(result[2].transaction.value, expences[2].transaction.value);
      expect(result[2].date.value, isNotNull);
      expect(result.last.id.value, isNotNull);

      expenceSubscription = expenceRepository!.onExpences.listen((newIncomes) {
        expect(newIncomes.length, expences.length);
      });
    });

    test('getById', () async {
      final Expence expence = await expenceRepository!.save(
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
      );

      final Expence? expenceById =
          await expenceRepository!.getById(expence.id.value!);

      expect(expenceById, isNotNull);
      expect(expenceById!.id.value, expence.id.value);
      expect(expenceById.category.value, category1);
      expect(expenceById.title.value, 'Expence 1');
      expect(expenceById.transaction.value, transaction1);
      expect(expenceById.date.value, isNotNull);
    });

    test('getList', () async {
      final List<Expence> incomes = await expenceRepository!.getList();

      expect(incomes, isEmpty);

      await expenceRepository!.saveAll([
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 1'
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..transaction.value = transaction2
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
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 2'
          ..transaction.value = transaction2
          ..date.value = DateTime.now().subtract(Durations.medium1),
        Expence()
          ..category.value = category1
          ..title.value = 'Expence 3'
          ..transaction.value = transaction3
          ..date.value = DateTime.now().subtract(Durations.medium2),
        Expence()
          ..category.value = category2
          ..title.value = 'Expence 4'
          ..transaction.value = transaction2
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
          ..transaction.value = transaction1
          ..date.value = DateTime.now(),
      );

      final int deleted = await expenceRepository!.delete(expence);

      expect(deleted, 1);

      final List<Expence> incomes = await expenceRepository!.getList();

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
