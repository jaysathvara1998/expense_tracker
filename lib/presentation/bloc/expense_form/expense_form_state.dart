// lib/presentation/bloc/expense_form/expense_form_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/expense.dart';

class ExpenseFormState extends Equatable {
  final String? id;
  final DateTime date;
  final TimeOfDay time;
  final String amount;
  final String? categoryId;
  final String description;
  final String location;
  final String paymentMode;
  final bool isEditing;
  final bool isSubmitting;
  final bool isFormValid;

  const ExpenseFormState({
    this.id,
    required this.date,
    required this.time,
    this.amount = '',
    this.categoryId,
    this.description = '',
    this.location = '',
    this.paymentMode = '',
    this.isEditing = false,
    this.isSubmitting = false,
    this.isFormValid = false,
  });

  // Factory method for initial state
  factory ExpenseFormState.initial() {
    return ExpenseFormState(
      date: DateTime.now(),
      time: TimeOfDay.now(),
      paymentMode: AppConstants.paymentModes.first,
    );
  }

  // Initialize from an existing expense
  factory ExpenseFormState.fromExpense(Expense expense) {
    return ExpenseFormState(
      id: expense.id,
      date: expense.date,
      time: TimeOfDay.fromDateTime(expense.date),
      amount: expense.amount.toString(),
      categoryId: expense.categoryId,
      description: expense.description,
      location: expense.location,
      paymentMode: expense.paymentMode,
      isEditing: true,
      isFormValid: true,
    );
  }

  // Helper method to convert form state to Expense entity
  Expense toExpense() {
    // Combine date and time
    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return Expense(
      id: id ?? '', // ID will be generated if not editing
      amount: double.tryParse(amount) ?? 0.0,
      date: dateTime,
      categoryId: categoryId ?? '',
      description: description,
      location: location,
      paymentMode: paymentMode,
    );
  }

  // Check if form is valid
  bool validateForm() {
    return amount.isNotEmpty &&
        double.tryParse(amount) != null &&
        double.tryParse(amount)! > 0 &&
        categoryId != null &&
        categoryId!.isNotEmpty &&
        description.isNotEmpty &&
        location.isNotEmpty;
  }

  // Create a copy with some changes
  ExpenseFormState copyWith({
    String? id,
    DateTime? date,
    TimeOfDay? time,
    String? amount,
    String? categoryId,
    String? description,
    String? location,
    String? paymentMode,
    bool? isEditing,
    bool? isSubmitting,
    bool? isFormValid,
  }) {
    return ExpenseFormState(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      location: location ?? this.location,
      paymentMode: paymentMode ?? this.paymentMode,
      isEditing: isEditing ?? this.isEditing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        id,
        date,
        time,
        amount,
        categoryId,
        description,
        location,
        paymentMode,
        isEditing,
        isSubmitting,
        isFormValid,
      ];
}
