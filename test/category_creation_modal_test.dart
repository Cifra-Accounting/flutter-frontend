import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cifra_app/widgets/category_creation_modal.dart';
import 'package:cifra_app/services/category_service.dart';

void main() {
  group('CategoryCreationModal Widget Tests', () {
    testWidgets('CategoryCreationModal displays correctly', (WidgetTester tester) async {
      final categoryService = CategoryService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryCreationModal(
              categoryService: categoryService,
            ),
          ),
        ),
      );

      // Check if the modal contains expected elements
      expect(find.text('Create New Category'), findsOneWidget);
      expect(find.text('Category Name *'), findsOneWidget);
      expect(find.text('Description (Optional)'), findsOneWidget);
      expect(find.text('Choose Color'), findsOneWidget);
      expect(find.text('Choose Icon'), findsOneWidget);
      expect(find.text('Create Category'), findsOneWidget);
    });

    testWidgets('CategoryCreationModal validates required fields', (WidgetTester tester) async {
      final categoryService = CategoryService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryCreationModal(
              categoryService: categoryService,
            ),
          ),
        ),
      );

      // Try to create category without entering name
      await tester.tap(find.text('Create Category'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter a category name'), findsOneWidget);
    });

    testWidgets('CategoryCreationModal creates category successfully', (WidgetTester tester) async {
      final categoryService = CategoryService();
      final initialCount = categoryService.categories.length;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryCreationModal(
              categoryService: categoryService,
            ),
          ),
        ),
      );

      // Enter category name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Category Name *'),
        'Test Category',
      );

      // Enter description
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description (Optional)'),
        'Test Description',
      );

      await tester.pump();

      // Tap create button
      await tester.tap(find.text('Create Category'));
      await tester.pump();

      // Verify category was created
      expect(categoryService.categories.length, initialCount + 1);
      
      // Find the created category
      final createdCategory = categoryService.categories.lastWhere(
        (category) => category.name == 'Test Category',
      );
      expect(createdCategory.description, 'Test Description');
    });

    testWidgets('CategoryCreationModal prevents duplicate names', (WidgetTester tester) async {
      final categoryService = CategoryService();

      // Add a category first
      categoryService.addCategory(
        name: 'Existing Category',
        color: Colors.blue,
        icon: Icons.category,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryCreationModal(
              categoryService: categoryService,
            ),
          ),
        ),
      );

      // Try to create category with existing name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Category Name *'),
        'Existing Category',
      );

      await tester.pump();

      // Tap create button
      await tester.tap(find.text('Create Category'));
      await tester.pump();

      // Should show validation error
      expect(find.text('A category with this name already exists'), findsOneWidget);
    });
  });
}