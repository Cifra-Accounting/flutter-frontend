import 'dart:async';

abstract class Repository<T> {
  FutureOr<T?> getById(int id);

  /// Retrieves a paginated list of items from the repository
  FutureOr<List<T>> getList({int? offset, int? limit, bool desc = false});

  /// Inserts or updates an item in the repository
  Future<void> save(T value);

  /// Inserts or updates a list of items in the repository
  Future<void> saveAll(List<T> values);

  /// Remove an item by its id
  Future<void> delete(int id);
}
