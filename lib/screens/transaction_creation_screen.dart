import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../widgets/category_creation_modal.dart';

class TransactionCreationScreen extends StatefulWidget {
  final CategoryService categoryService;

  const TransactionCreationScreen({
    super.key,
    required this.categoryService,
  });

  @override
  State<TransactionCreationScreen> createState() =>
      _TransactionCreationScreenState();
}

class _TransactionCreationScreenState extends State<TransactionCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  Category? _selectedCategory;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showCategoryCreationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: CategoryCreationModal(
          categoryService: widget.categoryService,
          onCategoryCreated: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
        ),
      ),
    );
  }

  void _showCategorySelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Category',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showCategoryCreationModal();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.categoryService,
                builder: (context, child) {
                  final categories = widget.categoryService.categories;
                  
                  if (categories.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No categories yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create your first category to get started',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showCategoryCreationModal();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Create Category'),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: category.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            category.icon,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(category.name),
                        subtitle: category.description != null
                            ? Text(category.description!)
                            : null,
                        trailing: _selectedCategory?.id == category.id
                            ? Icon(Icons.check, color: category.color)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTransaction() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category for this transaction'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // For now, just show a success message
    // In a real app, you would save the transaction to a service
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Transaction saved: \$${_amountController.text} - ${_selectedCategory!.name}',
        ),
        backgroundColor: Colors.green,
      ),
    );

    // Clear the form
    _amountController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount Field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount *',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value.trim());
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid positive amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter transaction description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),

              // Category Selection
              Text(
                'Category *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _showCategorySelectionSheet,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      if (_selectedCategory != null) ...[
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _selectedCategory!.color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _selectedCategory!.icon,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedCategory!.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (_selectedCategory!.description != null)
                                Text(
                                  _selectedCategory!.description!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.category_outlined,
                          color: Colors.grey[400],
                          size: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Select a category',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Save Button
              ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Transaction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}