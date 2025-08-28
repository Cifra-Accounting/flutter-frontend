import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cifra_app/models/category.dart';
import 'package:cifra_app/services/category_service.dart';

void main() {
  group('Category Model Tests', () {
    test('Category creation with required fields', () {
      final category = Category(
        id: 'test_id',
        name: 'Test Category',
        color: Colors.blue,
        icon: Icons.category,
      );

      expect(category.id, 'test_id');
      expect(category.name, 'Test Category');
      expect(category.color, Colors.blue);
      expect(category.icon, Icons.category);
      expect(category.description, isNull);
      expect(category.createdAt, isA<DateTime>());
    });

    test('Category creation with all fields', () {
      final now = DateTime.now();
      final category = Category(
        id: 'test_id',
        name: 'Test Category',
        description: 'Test Description',
        color: Colors.red,
        icon: Icons.shopping_bag,
        createdAt: now,
      );

      expect(category.id, 'test_id');
      expect(category.name, 'Test Category');
      expect(category.description, 'Test Description');
      expect(category.color, Colors.red);
      expect(category.icon, Icons.shopping_bag);
      expect(category.createdAt, now);
    });

    test('Category copyWith method', () {
      final original = Category(
        id: 'original_id',
        name: 'Original Name',
        color: Colors.blue,
        icon: Icons.category,
      );

      final updated = original.copyWith(name: 'Updated Name');

      expect(updated.id, 'original_id');
      expect(updated.name, 'Updated Name');
      expect(updated.color, Colors.blue);
      expect(updated.icon, Icons.category);
      expect(updated.createdAt, original.createdAt);
    });

    test('Category equality', () {
      final category1 = Category(
        id: 'same_id',
        name: 'Category 1',
        color: Colors.blue,
        icon: Icons.category,
      );

      final category2 = Category(
        id: 'same_id',
        name: 'Category 2',
        color: Colors.red,
        icon: Icons.shopping_bag,
      );

      final category3 = Category(
        id: 'different_id',
        name: 'Category 1',
        color: Colors.blue,
        icon: Icons.category,
      );

      expect(category1, category2); // Same ID
      expect(category1, isNot(category3)); // Different ID
    });
  });

  group('CategoryService Tests', () {
    test('CategoryService initializes with default categories', () {
      final service = CategoryService();
      
      expect(service.categories, isNotEmpty);
      expect(service.categories.length, greaterThan(0));
    });

    test('Adding a new category', () {
      final service = CategoryService();
      final initialCount = service.categories.length;

      final categoryId = service.addCategory(
        name: 'Test Category',
        description: 'Test Description',
        color: Colors.purple,
        icon: Icons.test_tube_outlined,
      );

      expect(service.categories.length, initialCount + 1);
      expect(categoryId, isNotEmpty);

      final addedCategory = service.getCategoryById(categoryId);
      expect(addedCategory, isNotNull);
      expect(addedCategory!.name, 'Test Category');
      expect(addedCategory.description, 'Test Description');
      expect(addedCategory.color, Colors.purple);
      expect(addedCategory.icon, Icons.test_tube_outlined);
    });

    test('Adding duplicate category name throws exception', () {
      final service = CategoryService();
      
      service.addCategory(
        name: 'Duplicate Category',
        color: Colors.blue,
        icon: Icons.category,
      );

      expect(
        () => service.addCategory(
          name: 'Duplicate Category',
          color: Colors.red,
          icon: Icons.shopping_bag,
        ),
        throwsException,
      );
    });

    test('Checking if category exists', () {
      final service = CategoryService();
      
      service.addCategory(
        name: 'Existing Category',
        color: Colors.blue,
        icon: Icons.category,
      );

      expect(service.categoryExists('Existing Category'), true);
      expect(service.categoryExists('existing category'), true); // Case insensitive
      expect(service.categoryExists('Non-existing Category'), false);
    });

    test('Updating a category', () {
      final service = CategoryService();
      
      final categoryId = service.addCategory(
        name: 'Original Name',
        description: 'Original Description',
        color: Colors.blue,
        icon: Icons.category,
      );

      service.updateCategory(
        id: categoryId,
        name: 'Updated Name',
        color: Colors.red,
      );

      final updatedCategory = service.getCategoryById(categoryId);
      expect(updatedCategory, isNotNull);
      expect(updatedCategory!.name, 'Updated Name');
      expect(updatedCategory.description, 'Original Description'); // Unchanged
      expect(updatedCategory.color, Colors.red);
      expect(updatedCategory.icon, Icons.category); // Unchanged
    });

    test('Deleting a category', () {
      final service = CategoryService();
      final initialCount = service.categories.length;
      
      final categoryId = service.addCategory(
        name: 'To Be Deleted',
        color: Colors.blue,
        icon: Icons.category,
      );

      expect(service.categories.length, initialCount + 1);

      service.deleteCategory(categoryId);

      expect(service.categories.length, initialCount);
      expect(service.getCategoryById(categoryId), isNull);
    });

    test('Searching categories', () {
      final service = CategoryService();
      
      service.addCategory(
        name: 'Food Expenses',
        description: 'Restaurant and grocery expenses',
        color: Colors.orange,
        icon: Icons.restaurant,
      );

      service.addCategory(
        name: 'Transportation',
        description: 'Car and public transport costs',
        color: Colors.blue,
        icon: Icons.directions_car,
      );

      // Search by name
      var results = service.searchCategories('Food');
      expect(results.length, 1);
      expect(results.first.name, 'Food Expenses');

      // Search by description
      results = service.searchCategories('restaurant');
      expect(results.length, 1);
      expect(results.first.name, 'Food Expenses');

      // Search case insensitive
      results = service.searchCategories('TRANSPORT');
      expect(results.length, 1);
      expect(results.first.name, 'Transportation');

      // Search with no results
      results = service.searchCategories('NonExistent');
      expect(results.length, 0);

      // Empty search returns all categories
      results = service.searchCategories('');
      expect(results.length, service.categories.length);
    });
  });
}
