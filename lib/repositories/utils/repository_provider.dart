import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/transactions/repository.dart';

class RepositoriesProvider extends StatefulWidget {
  const RepositoriesProvider(
      {super.key, required this.db, required this.child});

  final Database db;
  final Widget child;

  @override
  State<RepositoriesProvider> createState() => _RepositoryProviderState();
}

class _RepositoryProviderState extends State<RepositoriesProvider> {
  CategoryRepository? _categoryRepository;

  TransactionRepository? _transactionRepository;

  @override
  void dispose() {
    _categoryRepository?.dispose();
    _transactionRepository?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CategoryRepository>(
            create: (context) {
              _categoryRepository = CategoryRepository(db: widget.db);
              return _categoryRepository!;
            },
          ),
          RepositoryProvider<TransactionRepository>(
            create: (context) {
              _transactionRepository = TransactionRepository(db: widget.db);
              return _transactionRepository!;
            },
          ),
        ],
        child: widget.child,
      );
}
