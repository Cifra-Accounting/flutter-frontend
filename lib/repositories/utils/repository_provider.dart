import 'package:flutter/material.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cifra_app/repositories/categories/repository.dart';
import 'package:cifra_app/repositories/expences/repository.dart';
import 'package:cifra_app/repositories/incomes/repository.dart';

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

  IncomeRepository? _incomeRepository;
  ExpenceRepository? _expenceRepository;

  @override
  void dispose() {
    _categoryRepository?.dispose();
    _incomeRepository?.dispose();
    _expenceRepository?.dispose();

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
          RepositoryProvider<IncomeRepository>(
            create: (context) {
              _incomeRepository = IncomeRepository(db: widget.db);
              return _incomeRepository!;
            },
          ),
          RepositoryProvider<ExpenceRepository>(
            create: (context) {
              _expenceRepository = ExpenceRepository(db: widget.db);
              return _expenceRepository!;
            },
          ),
        ],
        child: widget.child,
      );
}
