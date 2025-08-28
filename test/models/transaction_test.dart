import 'package:flutter_test/flutter_test.dart';
import 'package:cifra_app/models/transaction.dart';
import 'package:cifra_app/models/category.dart';

void main() {
  group('Transaction', () {
    test('should create transaction correctly', () {
      final now = DateTime.now();
      final transaction = Transaction(
        id: 'test_id',
        categoryId: 'cat_id',
        amount: 100.50,
        description: 'Test transaction',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(transaction.id, 'test_id');
      expect(transaction.categoryId, 'cat_id');
      expect(transaction.amount, 100.50);
      expect(transaction.description, 'Test transaction');
    });

    test('should move to default category', () {
      final now = DateTime.now();
      final transaction = Transaction(
        id: 'test_id',
        categoryId: 'original_cat',
        amount: 100.50,
        description: 'Test transaction',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final moved = transaction.moveToDefaultCategory();

      expect(moved.categoryId, Category.defaultCategoryId);
      expect(moved.id, transaction.id);
      expect(moved.amount, transaction.amount);
      expect(moved.description, transaction.description);
      expect(moved.updatedAt.isAfter(transaction.updatedAt), true);
    });

    test('should convert to and from map correctly', () {
      final now = DateTime.now();
      final transaction = Transaction(
        id: 'test_id',
        categoryId: 'cat_id',
        amount: 100.50,
        description: 'Test transaction',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final map = transaction.toMap();
      final recreated = Transaction.fromMap(map);

      expect(recreated.id, transaction.id);
      expect(recreated.categoryId, transaction.categoryId);
      expect(recreated.amount, transaction.amount);
      expect(recreated.description, transaction.description);
      expect(recreated.transactionDate, transaction.transactionDate);
    });

    test('should handle equality correctly', () {
      final now = DateTime.now();
      final transaction1 = Transaction(
        id: 'test_id',
        categoryId: 'cat_id',
        amount: 100.50,
        description: 'Test transaction',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );
      
      final transaction2 = Transaction(
        id: 'test_id',
        categoryId: 'different_cat',
        amount: 200.00,
        description: 'Different transaction',
        transactionDate: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(transaction1, transaction2); // Same ID, should be equal
    });
  });
}