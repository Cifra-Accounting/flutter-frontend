import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

import 'package:cifra_app/c1fra/c1fra.dart';

import 'package:cifra_app/repositories/user/repository.dart';
import 'package:cifra_app/repositories/utils/repositories_provider.dart';
import 'package:cifra_app/repositories/utils/db_constants.dart';
import 'package:cifra_app/repositories/utils/db_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Database db = await initialize(dbName: dbName);
  final Dio dio = Dio(BaseOptions(
    headers: {"User-Agent": "c1fra/1.0.0-dev"},
    responseType: ResponseType.json,
    contentType: 'application/json',
  ));
  // ..interceptors.add(InterceptorsWrapper(
  //   onRequest: (options, handler) {
  //     print("REQUEST => ${options.uri}");
  //     return handler.next(options);
  //   },
  //   onResponse: (response, handler) {
  //     print("RESPONSE => ${response.data}");
  //     return handler.next(response);
  //   },
  // ));
  final UserRepository userRepository = UserRepository();
  await userRepository.init();

  runApp(RepositoriesProvider(
    db: db,
    dio: dio,
    userRepository: userRepository,
    child: const C1fra(),
  ));
}
