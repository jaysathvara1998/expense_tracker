import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/category/add_category.dart';
import '../../../domain/usecases/category/delete_category.dart' as delete;
import '../../../domain/usecases/category/get_all_categories.dart';
import '../../../domain/usecases/category/update_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategories getAllCategories;
  final AddCategory addCategory;
  final UpdateCategory updateCategory;
  final delete.DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getAllCategories,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<GetAllCategoriesEvent>(_onGetAllCategories);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onGetAllCategories(
    GetAllCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await getAllCategories(NoParams());

    result.fold(
      (failure) =>
          emit(const CategoryOperationFailure('Failed to load categories')),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }

  Future<void> _onAddCategory(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await addCategory(event.category);

    result.fold(
      (failure) =>
          emit(const CategoryOperationFailure('Failed to add category')),
      (_) {
        add(GetAllCategoriesEvent());
      },
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await updateCategory(event.category);

    result.fold(
      (failure) =>
          emit(const CategoryOperationFailure('Failed to update category')),
      (_) {
        add(GetAllCategoriesEvent());
      },
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await deleteCategory(delete.Params(id: event.id));

    result.fold(
      (failure) =>
          emit(const CategoryOperationFailure('Failed to delete category')),
      (_) {
        add(GetAllCategoriesEvent());
      },
    );
  }
}
