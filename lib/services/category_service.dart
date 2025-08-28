import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryService extends ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories => List.unmodifiable(_categories);

  // Predefined categories for initial setup
  static final List<Category> _defaultCategories = [
    Category(
      id: 'food',
      name: 'Food & Dining',
      description: 'Restaurants, groceries, and dining expenses',
      color: Colors.orange,
      icon: Icons.restaurant,
    ),
    Category(
      id: 'transport',
      name: 'Transportation',
      description: 'Car, public transport, fuel, and travel expenses',
      color: Colors.blue,
      icon: Icons.directions_car,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      description: 'Clothing, electronics, and general shopping',
      color: Colors.purple,
      icon: Icons.shopping_bag,
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      description: 'Movies, games, and leisure activities',
      color: Colors.pink,
      icon: Icons.movie,
    ),
    Category(
      id: 'utilities',
      name: 'Utilities',
      description: 'Electricity, water, internet, and phone bills',
      color: Colors.green,
      icon: Icons.electrical_services,
    ),
  ];

  CategoryService() {
    _loadDefaultCategories();
  }

  void _loadDefaultCategories() {
    _categories.addAll(_defaultCategories);
    notifyListeners();
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  bool categoryExists(String name) {
    return _categories.any(
      (category) => category.name.toLowerCase() == name.toLowerCase(),
    );
  }

  String addCategory({
    required String name,
    String? description,
    required Color color,
    required IconData icon,
  }) {
    if (categoryExists(name)) {
      throw Exception('Category with name "$name" already exists');
    }

    final id = _generateId();
    final category = Category(
      id: id,
      name: name,
      description: description,
      color: color,
      icon: icon,
    );

    _categories.add(category);
    notifyListeners();
    return id;
  }

  void updateCategory({
    required String id,
    String? name,
    String? description,
    Color? color,
    IconData? icon,
  }) {
    final index = _categories.indexWhere((category) => category.id == id);
    if (index == -1) {
      throw Exception('Category with id "$id" not found');
    }

    final oldCategory = _categories[index];
    
    // Check for name conflicts if name is being changed
    if (name != null && name != oldCategory.name && categoryExists(name)) {
      throw Exception('Category with name "$name" already exists');
    }

    final updatedCategory = oldCategory.copyWith(
      name: name,
      description: description,
      color: color,
      icon: icon,
    );

    _categories[index] = updatedCategory;
    notifyListeners();
  }

  void deleteCategory(String id) {
    final index = _categories.indexWhere((category) => category.id == id);
    if (index == -1) {
      throw Exception('Category with id "$id" not found');
    }

    _categories.removeAt(index);
    notifyListeners();
  }

  List<Category> searchCategories(String query) {
    if (query.isEmpty) {
      return categories;
    }

    final lowercaseQuery = query.toLowerCase();
    return _categories.where((category) {
      return category.name.toLowerCase().contains(lowercaseQuery) ||
          (category.description?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString();
    return 'cat_${timestamp}_$random';
  }
}