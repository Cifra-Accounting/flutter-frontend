import 'package:flutter_test/flutter_test.dart';
import 'package:cifra_app/models/category.dart';
import 'package:cifra_app/models/transaction.dart';
import 'package:cifra_app/repositories/in_memory_category_repository.dart';
import 'package:cifra_app/repositories/in_memory_transaction_repository.dart';
import 'package:cifra_app/services/category_service.dart';

void main() {
  group('CategoryService', () {
    late CategoryService categoryService;
    late InMemoryTransactionRepository transactionRepository;
    late InMemoryCategoryRepository categoryRepository;

    setUp(() {
      transactionRepository = InMemoryTransactionRepository();
      categoryRepository = InMemoryCategoryRepository(transactionRepository);
      categoryService = CategoryService(
        categoryRepository: categoryRepository,
        transactionRepository: transactionRepository,
      );
    });

    test('should create and retrieve categories', () async {
      final category = await categoryService.createCategory('Test Category', description: 'A test');
      
      expect(category.name, 'Test Category');
      expect(category.description, 'A test');
      expect(category.isDefault, false);

      final allCategories = await categoryService.getAllCategories();
      expect(allCategories, contains(category));
      // Should also contain the default category
      expect(allCategories.any((c) => c.isDefault), true);
    });

    test('should ensure default category exists', () async {
      final defaultCategory = await categoryService.getDefaultCategory();
      
      expect(defaultCategory.id, Category.defaultCategoryId);
      expect(defaultCategory.name, Category.defaultCategoryName);
      expect(defaultCategory.isDefault, true);
    });

    test('should delete category successfully when it has no transactions', () async {
      final category = await categoryService.createCategory('Test Category');
      
      final result = await categoryService.deleteCategory(category.id);
      
      expect(result.success, true);
      expect(result.transactionsMoved, 0);
      expect(result.message, contains('deleted successfully'));
    });

    test('should delete category and move transactions to default category', () async {
      // Create a category and some transactions
      final category = await categoryService.createCategory('Test Category');
      
      final now = DateTime.now();
      final transaction1 = Transaction(
        id: 'trans1',
        categoryId: category.id,
        amount: 100.0,
        description: 'Transaction 1',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );
      
      final transaction2 = Transaction(
        id: 'trans2',
        categoryId: category.id,
        amount: 200.0,
        description: 'Transaction 2',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );

      await transactionRepository.create(transaction1);
      await transactionRepository.create(transaction2);

      // Delete the category
      final result = await categoryService.deleteCategory(category.id);
      
      expect(result.success, true);
      expect(result.transactionsMoved, 2);
      expect(result.message, contains('2 transaction(s) moved'));

      // Verify transactions were moved to default category
      final defaultCategory = await categoryService.getDefaultCategory();
      final transactionsInDefault = await categoryService.getTransactionsForCategory(defaultCategory.id);
      
      expect(transactionsInDefault.length, 2);
      expect(transactionsInDefault.every((t) => t.categoryId == Category.defaultCategoryId), true);
    });

    test('should not delete default category', () async {
      final defaultCategory = await categoryService.getDefaultCategory();
      
      final result = await categoryService.deleteCategory(defaultCategory.id);
      
      expect(result.success, false);
      expect(result.transactionsMoved, 0);
      expect(result.message, contains('Cannot delete the default category'));
    });

    test('should throw exception when trying to delete non-existent category', () async {
      expect(
        () => categoryService.deleteCategory('non_existent_id'),
        throwsException,
      );
    });

    test('should update category successfully', () async {
      final category = await categoryService.createCategory('Original Name');
      final updated = category.copyWith(name: 'Updated Name');
      
      final result = await categoryService.updateCategory(updated);
      
      expect(result.name, 'Updated Name');
      expect(result.id, category.id);
    });
  });
}