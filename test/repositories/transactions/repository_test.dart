import 'package:cifra_app/common/models/money.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart'
    as models;
import 'package:cifra_app/repositories/transactions/repository.dart';

void main() {
  group('TransactionRepository', () {
    Database? db;
    CategoryRepository? categoryRepository;
    TransactionRepository? transactionRepository;

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
      transactionRepository = TransactionRepository(db: db!);

      await setUpCategories();
      setUpTransactions();
    });

    test('save', () async {
      final models.Transaction transaction = await transactionRepository!.save(
        models.Transaction()
          ..category.value = category1
          ..title.value = 'Transaction 1'
          ..value.value = transaction1
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
      );

      expect(transaction.id.value, isNotNull,
          reason: 'Transaction id is not null');
    });

    test('saveAll', () async {
      final List<models.Transaction> transactions =
          await transactionRepository!.saveAll([
        models.Transaction()
          ..category.value = category1
          ..title.value = 'models.Transaction 1'
          ..value.value = transaction1
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
        models.Transaction()
          ..category.value = category2
          ..title.value = 'models.Transaction 2'
          ..value.value = transaction2
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
      ]);

      expect(transactions.length, 2);

      expect(transactions.length, 2);

      expect(transactions.first.id.value, isNotNull);
      expect(transactions.first.category.value, category1);
      expect(transactions.first.title.value, 'models.Transaction 1');
      expect(transactions.first.value.value, transaction1);
      expect(transactions.first.type.value, models.TransactionType.expence);
      expect(transactions.first.date.value, isNotNull);

      expect(transactions.last.id.value, isNotNull);
      expect(transactions.last.category.value, category2);
      expect(transactions.last.title.value, 'models.Transaction 2');
      expect(transactions.last.value.value, transaction2);
      expect(transactions.first.type.value, models.TransactionType.expence);
      expect(transactions.last.date.value, isNotNull);
    });

    test('saveAll and update ', () async {
      List<models.Transaction> transactions = <models.Transaction>[
        models.Transaction()
          ..category.value = category1
          ..title.value = 'models.Transaction 1'
          ..value.value = transaction1
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now().subtract(Durations.medium2),
        models.Transaction()
          ..category.value = category2
          ..title.value = 'models.Transaction 2'
          ..value.value = transaction2
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now().subtract(Durations.medium1),
        models.Transaction()
          ..category.value = category1
          ..title.value = 'models.Transaction 3'
          ..value.value = transaction3
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
      ];

      transactions[0] = await transactionRepository!.save(transactions[0]);
      transactions[2] = await transactionRepository!.save(transactions[2]);

      transactions[0].value.value = transaction1!.copyWith(
        amountInSmallestUnits: 20000,
      );
      transactions[2].value.value = transaction3!.copyWith(
        amountInSmallestUnits: 800000,
      );

      final List<models.Transaction> result =
          await transactionRepository!.saveAll(transactions);

      expect(result.length, 3, reason: 'saveAll and update result list length');

      expect(result[0].id.value, transactions[0].id.value);
      expect(result[0].category.value, category1);
      expect(result[0].title.value, 'models.Transaction 1');
      expect(result[0].value.value, transactions[0].value.value);
      expect(result[0].type.value, transactions[0].type.value);
      expect(result[0].date.value, isNotNull);

      expect(result[1].id.value, 3);
      expect(result[1].category.value, category2);
      expect(result[1].title.value, 'models.Transaction 2');
      expect(result[1].value.value, transactions[1].value.value);
      expect(result[1].type.value, transactions[1].type.value);
      expect(result[1].date.value, isNotNull);

      expect(result[2].id.value, transactions[2].id.value);
      expect(result[2].category.value, category1);
      expect(result[2].title.value, 'models.Transaction 3');
      expect(result[2].value.value, transactions[2].value.value);
      expect(result[2].type.value, transactions[2].type.value);
      expect(result[2].date.value, isNotNull);

      expect(result.last.id.value, isNotNull);
    });

    test('getById', () async {
      final models.Transaction transaction = await transactionRepository!.save(
        models.Transaction()
          ..category.value = category1
          ..title.value = 'Transaction 1'
          ..value.value = transaction1
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
      );

      final models.Transaction? expenceById =
          await transactionRepository!.getById(transaction.id.value!);

      expect(expenceById, isNotNull);
      expect(expenceById!.id.value, transaction.id.value);
      expect(expenceById.category.value, category1);
      expect(expenceById.title.value, 'Transaction 1');
      expect(expenceById.value.value, transaction1);
      expect(expenceById.date.value, isNotNull);
    });

    test('getList', () async {
      final List<models.Transaction> incomes =
          await transactionRepository!.getList();

      expect(incomes, isEmpty);

      await transactionRepository!.saveAll([
        models.Transaction()
          ..category.value = category1
          ..title.value = 'models.Transaction 1'
          ..value.value = transaction1
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
        models.Transaction()
          ..category.value = category2
          ..title.value = 'models.Transaction 2'
          ..value.value = transaction2
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
      ]);

      final List<models.Transaction> incomesList =
          await transactionRepository!.getList();

      expect(incomesList.length, 2);
    });

    test('getList paginated', () async {
      final List<models.Transaction> incomes =
          await transactionRepository!.saveAll([
        models.Transaction()
          ..category.value = category1
          ..title.value = 'models.Transaction 1'
          ..value.value = transaction1
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
        models.Transaction()
          ..category.value = category2
          ..title.value = 'models.Transaction 2'
          ..value.value = transaction2
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now().subtract(Durations.medium1),
        models.Transaction()
          ..category.value = category1
          ..title.value = 'models.Transaction 3'
          ..value.value = transaction3
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now().subtract(Durations.medium2),
        models.Transaction()
          ..category.value = category2
          ..title.value = 'models.Transaction 4'
          ..value.value = transaction2
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now().subtract(Durations.medium3),
      ]);

      List<models.Transaction> result =
          await transactionRepository!.getList(offset: 1, limit: 2, desc: true);

      expect(result.first.id.value, incomes[1].id.value);
      expect(result.last.id.value, incomes[2].id.value);

      result = await transactionRepository!.getList(offset: 1, limit: 2);

      expect(result.first.id.value, incomes[2].id.value);
      expect(result.last.id.value, incomes[1].id.value);
    });

    test('delete', () async {
      final models.Transaction transaction = await transactionRepository!.save(
        models.Transaction()
          ..category.value = category1
          ..title.value = 'models.Transaction 1'
          ..value.value = transaction1
          ..type.value = models.TransactionType.expence
          ..date.value = DateTime.now(),
      );

      final int deleted = await transactionRepository!.delete(transaction);

      expect(deleted, 1);

      final List<models.Transaction> incomes =
          await transactionRepository!.getList();

      expect(incomes, isEmpty);
    });

    tearDown(() async {
      await transactionRepository?.dispose();
      await categoryRepository?.dispose();

      await db?.close();

      transaction1 = null;
      transaction2 = null;
      transaction3 = null;
    });
  });
}
