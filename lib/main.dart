import 'package:flutter/material.dart';

import 'package:cv/cv.dart';

import 'package:cifra_app/c1fra/c1fra.dart';

import 'package:cifra_app/repositories/categories/models/category.dart';
import 'package:cifra_app/repositories/expences/models/expence.dart';
import 'package:cifra_app/repositories/incomes/models/income.dart';

import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';

void main() async {
  cvAddConstructor<Income>(Income.new);
  cvAddConstructor<Category>(Category.new);
  cvAddConstructor<Expence>(Expence.new);

  WidgetsFlutterBinding.ensureInitialized();

  await initialize(dbName: dbName);

  runApp(const C1fra());
}
