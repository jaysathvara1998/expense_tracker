// lib/presentation/bloc/expense_form/expense_form_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/expense.dart';

abstract class ExpenseFormEvent extends Equatable {
  const ExpenseFormEvent();

  @override
  List<Object?> get props => [];
}

class InitializeExpenseFormEvent extends ExpenseFormEvent {
  final Expense? expense;

  const InitializeExpenseFormEvent(this.expense);

  @override
  List<Object?> get props => [expense];
}

class ChangeDateEvent extends ExpenseFormEvent {
  final DateTime date;

  const ChangeDateEvent(this.date);

  @override
  List<Object> get props => [date];
}

class ChangeTimeEvent extends ExpenseFormEvent {
  final TimeOfDay time;

  const ChangeTimeEvent(this.time);

  @override
  List<Object> get props => [time];
}

class ChangeAmountEvent extends ExpenseFormEvent {
  final String amount;

  const ChangeAmountEvent(this.amount);

  @override
  List<Object> get props => [amount];
}

class ChangeCategoryEvent extends ExpenseFormEvent {
  final String categoryId;

  const ChangeCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class ChangeDescriptionEvent extends ExpenseFormEvent {
  final String description;

  const ChangeDescriptionEvent(this.description);

  @override
  List<Object> get props => [description];
}

class ChangeLocationEvent extends ExpenseFormEvent {
  final String location;

  const ChangeLocationEvent(this.location);

  @override
  List<Object> get props => [location];
}

class ChangePaymentModeEvent extends ExpenseFormEvent {
  final String paymentMode;

  const ChangePaymentModeEvent(this.paymentMode);

  @override
  List<Object> get props => [paymentMode];
}

class SubmitExpenseFormEvent extends ExpenseFormEvent {
  const SubmitExpenseFormEvent();
}

class SubmittingExpenseFormEvent extends ExpenseFormEvent {
  const SubmittingExpenseFormEvent();
}

class DeleteExpenseEvent extends ExpenseFormEvent {
  final String id;

  const DeleteExpenseEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ValidateFormEvent extends ExpenseFormEvent {
  const ValidateFormEvent();
}
