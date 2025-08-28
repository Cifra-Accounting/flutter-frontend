import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../repositories/in_memory_category_repository.dart';
import '../repositories/in_memory_transaction_repository.dart';
import '../services/category_service.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  late CategoryService _categoryService;
  List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final transactionRepo = InMemoryTransactionRepository();
    final categoryRepo = InMemoryCategoryRepository(transactionRepo);
    _categoryService = CategoryService(
      categoryRepository: categoryRepo,
      transactionRepository: transactionRepo,
    );
    _loadCategories();
    _createSampleData();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    try {
      final categories = await _categoryService.getAllCategories();
      setState(() => _categories = categories);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createSampleData() async {
    // Create some sample categories and transactions
    final foodCategory = await _categoryService.createCategory('Food', description: 'Food and dining expenses');
    final transportCategory = await _categoryService.createCategory('Transport', description: 'Transportation costs');
    
    // Create sample transactions
    final transactionRepo = (_categoryService as dynamic)._transactionRepository;
    final now = DateTime.now();
    
    await transactionRepo.create(Transaction(
      id: 'trans1',
      categoryId: foodCategory.id,
      amount: 45.50,
      description: 'Restaurant lunch',
      transactionDate: now,
      createdAt: now,
      updatedAt: now,
    ));

    await transactionRepo.create(Transaction(
      id: 'trans2',
      categoryId: foodCategory.id,
      amount: 12.30,
      description: 'Coffee shop',
      transactionDate: now,
      createdAt: now,
      updatedAt: now,
    ));

    await transactionRepo.create(Transaction(
      id: 'trans3',
      categoryId: transportCategory.id,
      amount: 25.00,
      description: 'Bus ticket',
      transactionDate: now,
      createdAt: now,
      updatedAt: now,
    ));

    _loadCategories();
  }

  Future<void> _deleteCategory(String categoryId, String categoryName) async {
    final confirmed = await _showDeleteConfirmation(categoryName);
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      final result = await _categoryService.deleteCategory(categoryId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.success ? Colors.green : Colors.red,
          ),
        );
      }
      
      if (result.success) {
        _loadCategories();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _showDeleteConfirmation(String categoryName) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "$categoryName"?'),
            const SizedBox(height: 16),
            const Text(
              'Any transactions in this category will be moved to "NO CATEGORY".',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      category.isDefault ? Icons.home : Icons.category,
                      color: category.isDefault ? Colors.blue : Colors.grey,
                    ),
                    title: Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: category.isDefault ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: category.description != null
                        ? Text(category.description!)
                        : null,
                    trailing: category.isDefault
                        ? Chip(
                            label: const Text('DEFAULT'),
                            backgroundColor: Colors.blue.shade100,
                          )
                        : IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(category.id, category.name),
                          ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCategories,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}