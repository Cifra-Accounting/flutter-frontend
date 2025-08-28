import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../screens/home_screen.dart';

class C1fra extends StatefulWidget {
  const C1fra({super.key});

  @override
  State<C1fra> createState() => _C1fraState();
}

class _C1fraState extends State<C1fra> {
  late final CategoryService _categoryService;

  @override
  void initState() {
    super.initState();
    _categoryService = CategoryService();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cifra Accounting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[700],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: const CardTheme(
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(categoryService: _categoryService),
    );
  }
}
