// lib/presentation/bloc/loan_form/loan_form_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entities/loan.dart';

class LoanFormState extends Equatable {
  final String? id;
  final String personName;
  final String amount;
  final DateTime date;
  final DateTime? dueDate;
  final String description;
  final bool hasReminder;
  final LoanType type;
  final bool isSettled;
  final bool isEditing;
  final bool isSubmitting;
  final bool isFormValid;

  const LoanFormState({
    this.id,
    this.personName = '',
    this.amount = '',
    required this.date,
    this.dueDate,
    this.description = '',
    this.hasReminder = false,
    this.type = LoanType.borrowed,
    this.isSettled = false,
    this.isEditing = false,
    this.isSubmitting = false,
    this.isFormValid = false,
  });

  // Factory method for initial state
  factory LoanFormState.initial() {
    return LoanFormState(
      date: DateTime.now(),
    );
  }

  // Initialize from an existing loan
  factory LoanFormState.fromLoan(Loan loan) {
    return LoanFormState(
      id: loan.id,
      personName: loan.personName,
      amount: loan.amount.toString(),
      date: loan.date,
      dueDate: loan.dueDate,
      description: loan.description,
      hasReminder: loan.hasReminder,
      type: loan.type,
      isSettled: loan.isSettled,
      isEditing: true,
      isFormValid: true,
    );
  }

  // Helper method to convert form state to Loan entity
  Loan toLoan() {
    return Loan(
      id: id ?? '', // ID will be generated if not editing
      personName: personName,
      amount: double.tryParse(amount) ?? 0.0,
      date: date,
      dueDate: dueDate,
      description: description,
      hasReminder: hasReminder,
      type: type,
      isSettled: isSettled,
    );
  }

  // Check if form is valid
  bool validateForm() {
    return personName.isNotEmpty &&
        amount.isNotEmpty &&
        double.tryParse(amount) != null &&
        double.tryParse(amount)! > 0 &&
        description.isNotEmpty;
  }

  // Create a copy with some changes
  LoanFormState copyWith({
    String? id,
    String? personName,
    String? amount,
    DateTime? date,
    // Use Object? for dueDate to allow setting it to null
    Object? dueDate,
    String? description,
    bool? hasReminder,
    LoanType? type,
    bool? isSettled,
    bool? isEditing,
    bool? isSubmitting,
    bool? isFormValid,
  }) {
    return LoanFormState(
      id: id ?? this.id,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      dueDate: dueDate == null
          ? this.dueDate
          : (dueDate == LoanFormState)
              ? null
              : dueDate as DateTime?,
      description: description ?? this.description,
      hasReminder: hasReminder ?? this.hasReminder,
      type: type ?? this.type,
      isSettled: isSettled ?? this.isSettled,
      isEditing: isEditing ?? this.isEditing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFormValid: isFormValid ?? this.isFormValid,
    );
  }

  @override
  List<Object?> get props => [
        id,
        personName,
        amount,
        date,
        dueDate,
        description,
        hasReminder,
        type,
        isSettled,
        isEditing,
        isSubmitting,
        isFormValid,
      ];
}
