import 'package:equatable/equatable.dart';

import '../../../domain/entities/category.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryOperationSuccess extends CategoryState {}

class CategoryOperationFailure extends CategoryState {
  final String message;

  const CategoryOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}
