import 'package:cifra_app/repositories/currency_exchange/exchange_rate_repository.dart';
import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';

class RepositoriesProvider extends StatelessWidget {
  const RepositoriesProvider({
    super.key,
    required this.db,
    required this.dio,
    required this.userRepository,
    required this.child,
  });

  final Database db;
  final Dio dio;
  final Widget child;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ExchangeRateRepository>.value(
            value: ExchangeRateRepository(
              dio,
              baseUrl: "https://cdn.jsdelivr.net/npm/@fawazahmed0",
            ),
          ),
          RepositoryProvider<UserRepository>.value(value: userRepository),
          RepositoryProvider<CategoryRepository>(
            create: (context) => CategoryRepository(db: db),
            dispose: (repository) => repository.dispose(),
          ),
          RepositoryProvider<TransactionRepository>(
            create: (context) => TransactionRepository(db: db),
            dispose: (repository) => repository.dispose(),
          ),
        ],
        child: child,
      );
}
