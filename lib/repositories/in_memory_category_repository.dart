import '../models/category.dart';
import '../models/transaction.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';

/// In-memory implementation of CategoryRepository for demonstration
class InMemoryCategoryRepository implements CategoryRepository {
  static final Map<String, Category> _categories = {};
  
  final TransactionRepository _transactionRepository;
  
  InMemoryCategoryRepository(this._transactionRepository);

  @override
  Future<List<Category>> getAll() async {
    await ensureDefaultCategoryExists();
    return _categories.values.toList();
  }

  @override
  Future<Category?> getById(String id) async {
    await ensureDefaultCategoryExists();
    return _categories[id];
  }

  @override
  Future<Category> create(Category category) async {
    _categories[category.id] = category;
    return category;
  }

  @override
  Future<Category> update(Category category) async {
    if (!_categories.containsKey(category.id)) {
      throw Exception('Category with id ${category.id} not found');
    }
    
    final updatedCategory = category.copyWith(updatedAt: DateTime.now());
    _categories[category.id] = updatedCategory;
    return updatedCategory;
  }

  @override
  Future<bool> delete(String categoryId) async {
    // Ensure default category exists
    await ensureDefaultCategoryExists();
    
    // Cannot delete the default category
    if (categoryId == Category.defaultCategoryId) {
      return false;
    }
    
    final category = _categories[categoryId];
    if (category == null) {
      throw Exception('Category with id $categoryId not found');
    }
    
    // Move all transactions from this category to the default category
    await _transactionRepository.moveTransactionsToCategory(
      categoryId, 
      Category.defaultCategoryId
    );
    
    // Remove the category
    _categories.remove(categoryId);
    
    return true;
  }

  @override
  Future<Category> ensureDefaultCategoryExists() async {
    if (!_categories.containsKey(Category.defaultCategoryId)) {
      final defaultCategory = Category.createDefault();
      _categories[Category.defaultCategoryId] = defaultCategory;
      return defaultCategory;
    }
    return _categories[Category.defaultCategoryId]!;
  }

  @override
  Future<Category> getDefaultCategory() async {
    await ensureDefaultCategoryExists();
    return _categories[Category.defaultCategoryId]!;
  }
}