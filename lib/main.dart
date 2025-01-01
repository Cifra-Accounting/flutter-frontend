import 'package:flutter/material.dart';

import 'package:cifra_app/c1fra/c1fra.dart';

import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialize(dbName: dbName);

  runApp(const C1fra());
}
