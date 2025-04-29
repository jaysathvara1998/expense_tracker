// lib/presentation/bloc/loan_form/loan_form_event.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entities/loan.dart';

abstract class LoanFormEvent extends Equatable {
  const LoanFormEvent();

  @override
  List<Object?> get props => [];
}

class InitializeLoanFormEvent extends LoanFormEvent {
  final Loan? loan;

  const InitializeLoanFormEvent(this.loan);

  @override
  List<Object?> get props => [loan];
}

class ChangeLoanTypeEvent extends LoanFormEvent {
  final LoanType type;

  const ChangeLoanTypeEvent(this.type);

  @override
  List<Object> get props => [type];
}

class ChangePersonNameEvent extends LoanFormEvent {
  final String personName;

  const ChangePersonNameEvent(this.personName);

  @override
  List<Object> get props => [personName];
}

class ChangeAmountEvent extends LoanFormEvent {
  final String amount;

  const ChangeAmountEvent(this.amount);

  @override
  List<Object> get props => [amount];
}

class ChangeDateEvent extends LoanFormEvent {
  final DateTime date;

  const ChangeDateEvent(this.date);

  @override
  List<Object> get props => [date];
}

class ChangeDueDateEvent extends LoanFormEvent {
  final DateTime? dueDate;

  const ChangeDueDateEvent(this.dueDate);

  @override
  List<Object?> get props => [dueDate];
}

class ChangeDescriptionEvent extends LoanFormEvent {
  final String description;

  const ChangeDescriptionEvent(this.description);

  @override
  List<Object> get props => [description];
}

class ChangeReminderStatusEvent extends LoanFormEvent {
  final bool hasReminder;

  const ChangeReminderStatusEvent(this.hasReminder);

  @override
  List<Object> get props => [hasReminder];
}

class ChangeSettledStatusEvent extends LoanFormEvent {
  final bool isSettled;

  const ChangeSettledStatusEvent(this.isSettled);

  @override
  List<Object> get props => [isSettled];
}

class SubmitLoanFormEvent extends LoanFormEvent {
  const SubmitLoanFormEvent();
}

class SubmittingLoanFormEvent extends LoanFormEvent {
  const SubmittingLoanFormEvent();
}

class DeleteLoanEvent extends LoanFormEvent {
  final String id;

  const DeleteLoanEvent(this.id);

  @override
  List<Object> get props => [id];
}
