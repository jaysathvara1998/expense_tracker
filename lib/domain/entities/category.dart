import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, color, icon, isDefault];
}
