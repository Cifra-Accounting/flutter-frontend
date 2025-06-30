import 'dart:io';

import 'package:cifra_app/repositories/utils/db_constants.dart';
import 'package:cv/cv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqflite_ffi;

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/transactions/models/transaction.dart'
    as models;
import 'package:cifra_app/repositories/transactions/repository.dart';

Future<Database> initialize({required String dbName}) async {
  cvAddConstructor<models.Transaction>(models.Transaction.new);
  cvAddConstructor<Category>(Category.new);

  final Directory path = await getApplicationDocumentsDirectory();
  final String dbPath = join(path.path, "databases", dbName);

  if (Platform.isAndroid || Platform.isIOS) {
    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: kDbVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await db.execute(CategoryRepository.createQuery);

          await db.execute(TransactionRepository.createQuery);
          await db.execute(TransactionRepository.indexQuery);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (newVersion == 2 && oldVersion == 1) {
            await db.execute(TransactionRepository.createQuery);
            await db.execute(TransactionRepository.indexQuery);
            await db.delete('incomes');
            await db.delete('expences');
          }
        },
      ),
    );
  } else {
    sqflite_ffi.sqfliteFfiInit();

    return await sqflite_ffi.databaseFactoryFfi.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: kDbVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await db.execute(CategoryRepository.createQuery);

          await db.execute(TransactionRepository.createQuery);
          await db.execute(TransactionRepository.indexQuery);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (newVersion == 2 && oldVersion == 1) {
            await db.execute(TransactionRepository.createQuery);
            await db.execute(TransactionRepository.indexQuery);
            await db.delete('incomes');
            await db.delete('expences');
          }
        },
      ),
    );
  }
}

Future<Database> testInitialize() async {
  cvAddConstructor<models.Transaction>(models.Transaction.new);
  cvAddConstructor<Category>(Category.new);

  sqflite_ffi.sqfliteFfiInit();

  final Database db =
      await sqflite_ffi.databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(
            version: kDbVersion,
            onConfigure: (db) async {
              await db.execute('PRAGMA foreign_keys = ON');
            },
            onCreate: (db, version) async {
              await db.execute(CategoryRepository.createQuery);

              await db.execute(TransactionRepository.createQuery);
              await db.execute(TransactionRepository.indexQuery);
            },
          ));

  return db;
}
