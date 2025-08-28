import 'package:flutter_test/flutter_test.dart';
import 'package:cifra_app/models/category.dart';

void main() {
  group('Category', () {
    test('should create default category correctly', () {
      final category = Category.createDefault();
      
      expect(category.id, Category.defaultCategoryId);
      expect(category.name, Category.defaultCategoryName);
      expect(category.isDefault, true);
      expect(category.description, contains('Default category'));
    });

    test('should create regular category correctly', () {
      final now = DateTime.now();
      final category = Category(
        id: 'test_id',
        name: 'Test Category',
        description: 'A test category',
        createdAt: now,
        updatedAt: now,
      );

      expect(category.id, 'test_id');
      expect(category.name, 'Test Category');
      expect(category.description, 'A test category');
      expect(category.isDefault, false);
    });

    test('should convert to and from map correctly', () {
      final now = DateTime.now();
      final category = Category(
        id: 'test_id',
        name: 'Test Category',
        description: 'A test category',
        createdAt: now,
        updatedAt: now,
      );

      final map = category.toMap();
      final recreatedCategory = Category.fromMap(map);

      expect(recreatedCategory.id, category.id);
      expect(recreatedCategory.name, category.name);
      expect(recreatedCategory.description, category.description);
      expect(recreatedCategory.isDefault, category.isDefault);
      expect(recreatedCategory.createdAt, category.createdAt);
      expect(recreatedCategory.updatedAt, category.updatedAt);
    });

    test('should handle equality correctly', () {
      final now = DateTime.now();
      final category1 = Category(
        id: 'test_id',
        name: 'Test Category',
        createdAt: now,
        updatedAt: now,
      );
      
      final category2 = Category(
        id: 'test_id',
        name: 'Different Name',
        createdAt: now,
        updatedAt: now,
      );

      expect(category1, category2); // Same ID, should be equal
    });

    test('should copy with updated fields', () {
      final now = DateTime.now();
      final category = Category(
        id: 'test_id',
        name: 'Test Category',
        createdAt: now,
        updatedAt: now,
      );

      final updated = category.copyWith(name: 'Updated Name');

      expect(updated.id, category.id);
      expect(updated.name, 'Updated Name');
      expect(updated.createdAt, category.createdAt);
    });
  });
}