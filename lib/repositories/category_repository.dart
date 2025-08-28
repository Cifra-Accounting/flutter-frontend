import '../models/category.dart';

/// Abstract interface for category data operations
abstract class CategoryRepository {
  /// Gets all categories
  Future<List<Category>> getAll();
  
  /// Gets a category by ID
  Future<Category?> getById(String id);
  
  /// Creates a new category
  Future<Category> create(Category category);
  
  /// Updates an existing category
  Future<Category> update(Category category);
  
  /// Safely deletes a category by moving its transactions to default category
  /// Returns true if the category was deleted, false if it's the default category
  Future<bool> delete(String categoryId);
  
  /// Ensures the default "NO CATEGORY" category exists
  Future<Category> ensureDefaultCategoryExists();
  
  /// Gets the default category
  Future<Category> getDefaultCategory();
}