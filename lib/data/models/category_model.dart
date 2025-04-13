import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required String id,
    required String name,
    required Color color,
    required IconData icon,
    bool isDefault = false,
  }) : super(
          id: id,
          name: name,
          color: color,
          icon: icon,
          isDefault: isDefault,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
      'isDefault': isDefault,
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      color: category.color,
      icon: category.icon,
      isDefault: category.isDefault,
    );
  }
}
