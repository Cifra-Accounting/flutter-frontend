import 'dart:async';

import 'package:cifra_app/repositories/models/get_filter.dart';

abstract class Repository<T> {
  FutureOr<T?> getById(int id);

  /// Retrieves a paginated list of items from the repository
  FutureOr<List<T>> getList({
    int? offset,
    int? limit,
    bool desc = false,
    GetFilter? filter,
  });

  /// Inserts or updates an item in the repository
  Future<T> save(T value);

  /// Inserts or updates a list of items in the repository
  Future<List<T>> saveAll(List<T> values);

  /// Remove an item with id from the repository
  Future<int> delete(T value);
}
