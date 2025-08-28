import '../models/category.dart';
import '../models/transaction.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';

/// Service to handle category operations with business logic
class CategoryService {
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;

  CategoryService({
    required CategoryRepository categoryRepository,
    required TransactionRepository transactionRepository,
  })  : _categoryRepository = categoryRepository,
        _transactionRepository = transactionRepository;

  /// Gets all categories
  Future<List<Category>> getAllCategories() async {
    return await _categoryRepository.getAll();
  }

  /// Creates a new category
  Future<Category> createCategory(String name, {String? description}) async {
    final now = DateTime.now();
    final category = Category(
      id: _generateId(),
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
    
    return await _categoryRepository.create(category);
  }

  /// Updates an existing category
  Future<Category> updateCategory(Category category) async {
    return await _categoryRepository.update(category);
  }

  /// Safely deletes a category by moving its transactions to the default category
  /// Returns a result indicating success and the number of transactions moved
  Future<CategoryDeletionResult> deleteCategory(String categoryId) async {
    // Get the category to check if it exists
    final category = await _categoryRepository.getById(categoryId);
    if (category == null) {
      throw Exception('Category with id $categoryId not found');
    }

    // Cannot delete the default category
    if (category.isDefault) {
      return CategoryDeletionResult(
        success: false,
        transactionsMoved: 0,
        message: 'Cannot delete the default category',
      );
    }

    // Get all transactions in this category before deletion
    final transactionsInCategory = await _transactionRepository.getByCategoryId(categoryId);
    final transactionCount = transactionsInCategory.length;

    // Perform the deletion (this moves transactions to default category)
    final deleted = await _categoryRepository.delete(categoryId);

    if (deleted) {
      return CategoryDeletionResult(
        success: true,
        transactionsMoved: transactionCount,
        message: transactionCount > 0 
            ? 'Category deleted successfully. $transactionCount transaction(s) moved to "NO CATEGORY"'
            : 'Category deleted successfully',
      );
    } else {
      return CategoryDeletionResult(
        success: false,
        transactionsMoved: 0,
        message: 'Failed to delete category',
      );
    }
  }

  /// Gets the default "NO CATEGORY" category
  Future<Category> getDefaultCategory() async {
    return await _categoryRepository.getDefaultCategory();
  }

  /// Gets all transactions for a specific category
  Future<List<Transaction>> getTransactionsForCategory(String categoryId) async {
    return await _transactionRepository.getByCategoryId(categoryId);
  }

  /// Generates a unique ID for new categories
  String _generateId() {
    return 'cat_${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(6)}';
  }

  /// Generates a random string for ID uniqueness
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(length, (index) => chars[(random + index) % chars.length]).join();
  }
}

/// Result of a category deletion operation
class CategoryDeletionResult {
  final bool success;
  final int transactionsMoved;
  final String message;

  CategoryDeletionResult({
    required this.success,
    required this.transactionsMoved,
    required this.message,
  });

  @override
  String toString() {
    return 'CategoryDeletionResult(success: $success, transactionsMoved: $transactionsMoved, message: $message)';
  }
}