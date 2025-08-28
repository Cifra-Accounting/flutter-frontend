import '../models/transaction.dart';

/// Abstract interface for transaction data operations
abstract class TransactionRepository {
  /// Gets all transactions
  Future<List<Transaction>> getAll();
  
  /// Gets a transaction by ID
  Future<Transaction?> getById(String id);
  
  /// Gets all transactions for a specific category
  Future<List<Transaction>> getByCategoryId(String categoryId);
  
  /// Creates a new transaction
  Future<Transaction> create(Transaction transaction);
  
  /// Updates an existing transaction
  Future<Transaction> update(Transaction transaction);
  
  /// Deletes a transaction
  Future<bool> delete(String transactionId);
  
  /// Moves all transactions from one category to another
  /// This is used when deleting a category
  Future<int> moveTransactionsToCategory(String fromCategoryId, String toCategoryId);
}