import 'package:cifra_app/repositories/user/repository.dart';
import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';

class RepositoriesProvider extends StatelessWidget {
  const RepositoriesProvider({
    super.key,
    required this.db,
    required this.userRepository,
    required this.child,
  });

  final Database db;
  final Widget child;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>(
            create: (context) => userRepository,
          ),
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
