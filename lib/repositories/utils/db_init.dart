import 'dart:io';

import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cv/cv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/expences/models/expence.dart';
import 'package:cifra_app/repositories/expences/repository.dart';
import 'package:cifra_app/repositories/incomes/models/income.dart';
import 'package:cifra_app/repositories/incomes/repository.dart';

Future<Database> initialize({required String dbName}) async {
  cvAddConstructor<Income>(Income.new);
  cvAddConstructor<Category>(Category.new);
  cvAddConstructor<Expence>(Expence.new);

  sqfliteFfiInit();

  final Directory path = await getApplicationDocumentsDirectory();
  final String dbPath = join(path.path, "databases", dbName);

  final Database db = await databaseFactoryFfi.openDatabase(dbPath,
      options: OpenDatabaseOptions(
        version: kDbVersion,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
        onCreate: (db, version) async {
          await db.execute(CategoryRepository.createQuery);

          await db.execute(ExpenceRepository.createQuery);
          await db.execute(ExpenceRepository.indexQuery);

          await db.execute(IncomeRepository.createQuery);
          await db.execute(IncomeRepository.indexQuery);
        },
      ));

  return db;
}

Future<Database> testInitialize() async {
  cvAddConstructor<Income>(Income.new);
  cvAddConstructor<Category>(Category.new);
  cvAddConstructor<Expence>(Expence.new);

  sqfliteFfiInit();

  final Database db =
      await databaseFactoryFfi.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(
            version: kDbVersion,
            onConfigure: (db) async {
              await db.execute('PRAGMA foreign_keys = ON');
            },
            onCreate: (db, version) async {
              await db.execute(CategoryRepository.createQuery);

              await db.execute(ExpenceRepository.createQuery);
              await db.execute(ExpenceRepository.indexQuery);

              await db.execute(IncomeRepository.createQuery);
              await db.execute(IncomeRepository.indexQuery);
            },
          ));

  return db;
}
