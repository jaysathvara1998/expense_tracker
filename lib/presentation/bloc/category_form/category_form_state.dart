// lib/presentation/bloc/category_form/category_form_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/category.dart';

class CategoryFormState extends Equatable {
  final String? id;
  final String name;
  final Color color;
  final IconData icon;
  final bool isDefault;
  final bool isEditing;
  final bool isSubmitting;
  final bool isFormValid;

  const CategoryFormState({
    this.id,
    this.name = '',
    required this.color,
    required this.icon,
    this.isDefault = false,
    this.isEditing = false,
    this.isSubmitting = false,
    this.isFormValid = false,
  });

  // Factory method for initial state
  factory CategoryFormState.initial() {
    return CategoryFormState(
      color: AppConstants.categoryColors.first,
      icon: AppConstants.categoryIcons.first,
    );
  }

  // Initialize from an existing category
  factory CategoryFormState.fromCategory(Category category) {
    return CategoryFormState(
      id: category.id,
      name: category.name,
      color: category.color,
      icon: category.icon,
      isDefault: category.isDefault,
      isEditing: true,
      isFormValid: category.name.isNotEmpty,
    );
  }

  // Helper method to convert form state to Category entity
  Category toCategory() {
    return Category(
      id: id ?? '', // ID will be generated if not editing
      name: name,
      color: color,
      icon: icon,
      isDefault: isDefault,
    );
  }

  // Check if form is valid
  bool validateForm() {
    return name.isNotEmpty;
  }

  // Create a copy with some changes
  CategoryFormState copyWith({
    String? id,
    String? name,
    Color? color,
    IconData? icon,
    bool? isDefault,
    bool? isEditing,
    bool? isSubmitting,
    bool? isFormValid,
  }) {
    return CategoryFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      isEditing: isEditing ?? this.isEditing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        icon,
        isDefault,
        isEditing,
        isSubmitting,
        isFormValid,
      ];
}
