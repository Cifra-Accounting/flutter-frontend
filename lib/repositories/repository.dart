import 'dart:async';

abstract class Repository<T> {
  /// Retrieves all items from the repository
  FutureOr<List<T>> getAll();

  /// Retrieves a paginated list of items from the repository
  FutureOr<List<T>> getPage(int offset, int limit);

  /// Retrieves a specific item by index
  FutureOr<T?> getAt(int index);

  /// Inserts or updates an item in the repository
  Future<void> put(T newValue);

  Future<void> putAll(List<T> newValues);

  /// Remove an item by its identifier or index
  Future<void> delete(int index);

  /// Update an item by its identifier or index
  Future<void> update(int index, T newValue);
}
