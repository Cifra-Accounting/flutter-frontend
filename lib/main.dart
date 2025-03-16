import 'package:flutter/material.dart';

import 'package:cifra_app/c1fra/c1fra.dart';

import 'package:cifra_app/repositories/user/repository.dart';
import 'package:cifra_app/repositories/utils/repositories_provider.dart';
import 'package:cifra_app/repositories/models/db_constants.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Database db = await initialize(dbName: dbName);
  final UserRepository userRepository = UserRepository();
  await userRepository.init();

  runApp(RepositoriesProvider(
    userRepository: userRepository,
    db: db,
    child: const C1fra(),
  ));
}
