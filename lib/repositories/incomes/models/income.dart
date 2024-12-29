import 'package:cifra_app/repositories/expences/models/expence.dart';

class Income {
  const Income({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
  });

  final int id;
  final String title;
  final Category category;
  final double amount;
  final DateTime date;
  final String? description;

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'] as int,
      title: json['title'] as String,
      category: Category.fromJson(json),
      amount: json['amount'] as double,
      date: DateTime.parse(json['date']),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson({required int categoryId}) {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category_id': categoryId,
      'amount': amount,
      'date': date.toIso8601String(),
      if (description != null) 'description': description,
    };
  }
}
