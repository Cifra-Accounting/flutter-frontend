class Expence {
  const Expence({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
  });

  final String title;
  final Category category;
  final double amount;
  final DateTime date;
  final String? description;

  Expence.fromJson(Map<String, dynamic> json)
      : title = json["title"] as String,
        category = Category.fromJson(json),
        amount = json["amount"] as double,
        date = DateTime.parse(json["date"] as String),
        description = json["description"] as String?;

  Map<String, dynamic> toJson({required int categoryId}) => <String, dynamic>{
        "title": title,
        "category_id": categoryId,
        "amount": amount,
        "date": date.toIso8601String(),
        "description": description,
      };
}

class Category {
  const Category({required this.name, required this.icon});

  final String name;
  final int icon;

  Category.fromJson(Map<String, dynamic> json)
      : name = json["name"] as String,
        icon = json["icon"] as int;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "name": name,
        "icon": icon,
      };
}
