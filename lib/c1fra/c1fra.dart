import 'package:flutter/material.dart';
import '../screens/category_management_screen.dart';

class C1fra extends StatelessWidget {
  const C1fra({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cifra Accounting App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CategoryManagementScreen(),
    );
  }
}
