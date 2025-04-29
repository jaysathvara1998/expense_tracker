// lib/presentation/bloc/expense_form/expense_form_bloc.dart
import 'package:expanse_tracker/presentation/bloc/expense_form/expense_form_event.dart';
import 'package:expanse_tracker/presentation/bloc/expense_form/expense_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/expense.dart';
import '../expense/expense_bloc.dart';
import '../expense/expense_event.dart' as expense_event;

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  final ExpenseBloc expenseBloc;

  ExpenseFormBloc({required this.expenseBloc})
      : super(ExpenseFormState.initial()) {
    on<InitializeExpenseFormEvent>(_onInitializeForm);
    on<ChangeDateEvent>(_onChangeDate);
    on<ChangeTimeEvent>(_onChangeTime);
    on<ChangeAmountEvent>(_onChangeAmount);
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<ChangeDescriptionEvent>(_onChangeDescription);
    on<ChangeLocationEvent>(_onChangeLocation);
    on<ChangePaymentModeEvent>(_onChangePaymentMode);
    on<SubmitExpenseFormEvent>(_onSubmitForm);
    on<SubmittingExpenseFormEvent>(_onSubmittingForm);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<ValidateFormEvent>(_onValidateForm);
  }

  void _onInitializeForm(
    InitializeExpenseFormEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    if (event.expense != null) {
      emit(ExpenseFormState.fromExpense(event.expense!));
    } else {
      emit(ExpenseFormState.initial());
    }
  }

  void _onChangeDate(
    ChangeDateEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  void _onChangeTime(
    ChangeTimeEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(time: event.time));
  }

  void _onChangeAmount(
    ChangeAmountEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    final isFormValid = state.copyWith(amount: event.amount).validateForm();
    emit(state.copyWith(
      amount: event.amount,
      isFormValid: isFormValid,
    ));
  }

  void _onChangeCategory(
    ChangeCategoryEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    final isFormValid =
        state.copyWith(categoryId: event.categoryId).validateForm();
    emit(state.copyWith(
      categoryId: event.categoryId,
      isFormValid: isFormValid,
    ));
  }

  void _onChangeDescription(
    ChangeDescriptionEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    final isFormValid =
        state.copyWith(description: event.description).validateForm();
    emit(state.copyWith(
      description: event.description,
      isFormValid: isFormValid,
    ));
  }

  void _onChangeLocation(
    ChangeLocationEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    final isFormValid = state.copyWith(location: event.location).validateForm();
    emit(state.copyWith(
      location: event.location,
      isFormValid: isFormValid,
    ));
  }

  void _onChangePaymentMode(
    ChangePaymentModeEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(paymentMode: event.paymentMode));
  }

  void _onValidateForm(
    ValidateFormEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    final isFormValid = state.validateForm();
    emit(state.copyWith(isFormValid: isFormValid));
  }

  void _onSubmittingForm(
    SubmittingExpenseFormEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(isSubmitting: true));
  }

  void _onSubmitForm(
    SubmitExpenseFormEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    if (!state.validateForm()) return;

    emit(state.copyWith(isSubmitting: true));

    final expense = Expense(
      id: state.id ?? const Uuid().v4(),
      amount: double.parse(state.amount),
      date: DateTime(
        state.date.year,
        state.date.month,
        state.date.day,
        state.time.hour,
        state.time.minute,
      ),
      categoryId: state.categoryId!,
      description: state.description,
      location: state.location,
      paymentMode: state.paymentMode,
    );

    if (state.isEditing) {
      expenseBloc.add(expense_event.UpdateExpenseEvent(expense));
    } else {
      expenseBloc.add(expense_event.AddExpenseEvent(expense));
    }
  }

  void _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseFormState> emit,
  ) {
    emit(state.copyWith(isSubmitting: true));
    expenseBloc.add(expense_event.DeleteExpenseEvent(event.id));
  }
}
