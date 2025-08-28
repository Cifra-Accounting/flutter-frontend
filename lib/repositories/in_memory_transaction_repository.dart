import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

/// In-memory implementation of TransactionRepository for demonstration
class InMemoryTransactionRepository implements TransactionRepository {
  static final Map<String, Transaction> _transactions = {};

  @override
  Future<List<Transaction>> getAll() async {
    return _transactions.values.toList();
  }

  @override
  Future<Transaction?> getById(String id) async {
    return _transactions[id];
  }

  @override
  Future<List<Transaction>> getByCategoryId(String categoryId) async {
    return _transactions.values
        .where((transaction) => transaction.categoryId == categoryId)
        .toList();
  }

  @override
  Future<Transaction> create(Transaction transaction) async {
    _transactions[transaction.id] = transaction;
    return transaction;
  }

  @override
  Future<Transaction> update(Transaction transaction) async {
    if (!_transactions.containsKey(transaction.id)) {
      throw Exception('Transaction with id ${transaction.id} not found');
    }
    
    final updatedTransaction = transaction.copyWith(updatedAt: DateTime.now());
    _transactions[transaction.id] = updatedTransaction;
    return updatedTransaction;
  }

  @override
  Future<bool> delete(String transactionId) async {
    final removed = _transactions.remove(transactionId);
    return removed != null;
  }

  @override
  Future<int> moveTransactionsToCategory(String fromCategoryId, String toCategoryId) async {
    int movedCount = 0;
    final transactionsToMove = <String>[];
    
    // Find all transactions with the source category
    for (final entry in _transactions.entries) {
      if (entry.value.categoryId == fromCategoryId) {
        transactionsToMove.add(entry.key);
      }
    }
    
    // Move transactions to the new category
    for (final transactionId in transactionsToMove) {
      final transaction = _transactions[transactionId];
      if (transaction != null) {
        final updatedTransaction = transaction.copyWith(
          categoryId: toCategoryId,
          updatedAt: DateTime.now(),
        );
        _transactions[transactionId] = updatedTransaction;
        movedCount++;
      }
    }
    
    return movedCount;
  }
}