import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryCreationModal extends StatefulWidget {
  final CategoryService categoryService;
  final Function(Category)? onCategoryCreated;

  const CategoryCreationModal({
    super.key,
    required this.categoryService,
    this.onCategoryCreated,
  });

  @override
  State<CategoryCreationModal> createState() => _CategoryCreationModalState();
}

class _CategoryCreationModalState extends State<CategoryCreationModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.category;
  bool _isLoading = false;

  static const List<Color> _availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.cyan,
  ];

  static const List<IconData> _availableIcons = [
    Icons.category,
    Icons.restaurant,
    Icons.directions_car,
    Icons.shopping_bag,
    Icons.movie,
    Icons.electrical_services,
    Icons.home,
    Icons.health_and_safety,
    Icons.school,
    Icons.work,
    Icons.sports_esports,
    Icons.local_gas_station,
    Icons.phone,
    Icons.computer,
    Icons.pets,
    Icons.flight,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final categoryId = widget.categoryService.addCategory(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
      );

      final createdCategory = widget.categoryService.getCategoryById(categoryId);
      
      if (createdCategory != null && widget.onCategoryCreated != null) {
        widget.onCategoryCreated!(createdCategory);
      }

      if (mounted) {
        Navigator.of(context).pop(createdCategory);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "${_nameController.text}" created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating category: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create New Category',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name *',
                    hintText: 'Enter category name',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a category name';
                    }
                    if (value.trim().length < 2) {
                      return 'Category name must be at least 2 characters';
                    }
                    if (widget.categoryService.categoryExists(value.trim())) {
                      return 'A category with this name already exists';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter category description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),

                // Color Selection
                Text(
                  'Choose Color',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 3)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Icon Selection
                Text(
                  'Choose Icon',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableIcons.map((icon) {
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(color: _selectedColor, width: 2)
                              : Border.all(color: Colors.grey.withOpacity(0.3)),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? _selectedColor : Colors.grey[600],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _selectedIcon,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nameController.text.isEmpty
                                  ? 'Category Name'
                                  : _nameController.text,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_descriptionController.text.isNotEmpty)
                              Text(
                                _descriptionController.text,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Create Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _createCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Create Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}