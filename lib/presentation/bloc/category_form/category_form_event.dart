// lib/presentation/bloc/category_form/category_form_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/category.dart';

abstract class CategoryFormEvent extends Equatable {
  const CategoryFormEvent();

  @override
  List<Object?> get props => [];
}

class InitializeCategoryFormEvent extends CategoryFormEvent {
  final Category? category;

  const InitializeCategoryFormEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class ChangeCategoryNameEvent extends CategoryFormEvent {
  final String name;

  const ChangeCategoryNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class ChangeCategoryColorEvent extends CategoryFormEvent {
  final Color color;

  const ChangeCategoryColorEvent(this.color);

  @override
  List<Object> get props => [color];
}

class ChangeCategoryIconEvent extends CategoryFormEvent {
  final IconData icon;

  const ChangeCategoryIconEvent(this.icon);

  @override
  List<Object> get props => [icon];
}

class SubmitCategoryFormEvent extends CategoryFormEvent {
  const SubmitCategoryFormEvent();
}

class SubmittingCategoryFormEvent extends CategoryFormEvent {
  const SubmittingCategoryFormEvent();
}

class DeleteCategoryEvent extends CategoryFormEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object> get props => [id];
}
