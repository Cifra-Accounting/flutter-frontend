import 'dart:io';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/expences/repository.dart';
import 'package:cifra_app/repositories/incomes/repository.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<Database> initialize({required String dbName}) async {
  sqfliteFfiInit();

  final Directory path = await getApplicationDocumentsDirectory();
  final String dbPath = join(path.path, "databases", dbName);

  final Database db = await databaseFactoryFfi.openDatabase(dbPath,
      options: OpenDatabaseOptions(
        version: 0,
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
