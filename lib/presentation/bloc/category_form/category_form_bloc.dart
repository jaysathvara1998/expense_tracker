// lib/presentation/bloc/category_form/category_form_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/category.dart';
import '../category/category_bloc.dart';
import '../category/category_event.dart' as category_event;
import 'category_form_event.dart';
import 'category_form_state.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  final CategoryBloc categoryBloc;

  CategoryFormBloc({required this.categoryBloc})
      : super(CategoryFormState.initial()) {
    on<InitializeCategoryFormEvent>(_onInitializeForm);
    on<ChangeCategoryNameEvent>(_onChangeName);
    on<ChangeCategoryColorEvent>(_onChangeColor);
    on<ChangeCategoryIconEvent>(_onChangeIcon);
    on<SubmitCategoryFormEvent>(_onSubmitForm);
    on<SubmittingCategoryFormEvent>(_onSubmittingForm);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  void _onInitializeForm(
    InitializeCategoryFormEvent event,
    Emitter<CategoryFormState> emit,
  ) {
    if (event.category != null) {
      emit(CategoryFormState.fromCategory(event.category!));
    } else {
      emit(CategoryFormState.initial());
    }
  }

  void _onChangeName(
    ChangeCategoryNameEvent event,
    Emitter<CategoryFormState> emit,
  ) {
    final isFormValid = state.copyWith(name: event.name).validateForm();
    emit(state.copyWith(
      name: event.name,
      isFormValid: isFormValid,
    ));
  }

  void _onChangeColor(
    ChangeCategoryColorEvent event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(color: event.color));
  }

  void _onChangeIcon(
    ChangeCategoryIconEvent event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(icon: event.icon));
  }

  void _onSubmittingForm(
    SubmittingCategoryFormEvent event,
    Emitter<CategoryFormState> emit,
  ) {
    emit(state.copyWith(isSubmitting: false));
  }

  void _onSubmitForm(
    SubmitCategoryFormEvent event,
    Emitter<CategoryFormState> emit,
  ) {
    if (!state.validateForm() || state.isDefault) return;

    emit(state.copyWith(isSubmitting: true));

    final category = Category(
      id: state.id ?? const Uuid().v4(),
      name: state.name,
      color: state.color,
      icon: state.icon,
      isDefault: state.isDefault,
    );

    if (state.isEditing) {
      categoryBloc.add(category_event.UpdateCategoryEvent(category));
    } else {
      categoryBloc.add(category_event.AddCategoryEvent(category));
    }
  }

  void _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<CategoryFormState> emit,
  ) {
    if (state.isDefault) return; // Cannot delete default categories

    emit(state.copyWith(isSubmitting: true));
    categoryBloc.add(category_event.DeleteCategoryEvent(event.id));
  }
}
