class Category {
  final String id;
  final String name;
  final String? description;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  static const String defaultCategoryId = 'no_category_default';
  static const String defaultCategoryName = 'NO CATEGORY';

  /// Creates the default "NO CATEGORY" category
  static Category createDefault() {
    final now = DateTime.now();
    return Category(
      id: defaultCategoryId,
      name: defaultCategoryName,
      description: 'Default category for transactions without a specific category',
      isDefault: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Creates a copy of this category with updated fields
  Category copyWith({
    String? id,
    String? name,
    String? description,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts category to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isDefault': isDefault ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Creates category from map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      isDefault: (map['isDefault'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, isDefault: $isDefault)';
  }
}