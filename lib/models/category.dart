import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String? description;
  final Color color;
  final IconData icon;
  final DateTime createdAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    required this.color,
    required this.icon,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Category copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    IconData? icon,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color.value,
      'icon': icon.codePoint,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category{id: $id, name: $name, color: $color, icon: $icon}';
  }
}