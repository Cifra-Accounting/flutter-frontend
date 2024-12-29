import 'dart:io';
import 'package:cifra_app/c1fra/c1fra.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();

  final Directory path = await getApplicationDocumentsDirectory();
  final String dbPath = join(path.path, "databases", "c1fra.db");

  final Database db = await databaseFactoryFfi.openDatabase(dbPath);

  await db.execute("""
    PRAGMA foreign_keys = ON

    CREATE TABLE IF NOT EXISTS Categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      icon INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS Incomes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      date DATETIME NOT NULL,
      description TEXT DEFAULT '',
      CONSTRAINT category_idx
        FOREIGN KEY (category_id)
        REFRENCES Categories (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Expences (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      category_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      date DATETIME NOT NULL,
      description TEXT DEFAULT '',
      CONSTRAINT category_idx
        FOREIGN KEY (category_id)
        REFRENCES Categories (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
    )
    """);

  runApp(const C1fra());
}
