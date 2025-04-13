import 'package:equatable/equatable.dart';

import '../../../domain/entities/loan.dart';

abstract class LoanState extends Equatable {
  const LoanState();

  @override
  List<Object> get props => [];
}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoansLoaded extends LoanState {
  final List<Loan> loans;

  const LoansLoaded(this.loans);

  @override
  List<Object> get props => [loans];
}

class ReminderLoansLoaded extends LoanState {
  final List<Loan> loans;

  const ReminderLoansLoaded(this.loans);

  @override
  List<Object> get props => [loans];
}

class LoanOperationSuccess extends LoanState {}

class LoanOperationFailure extends LoanState {
  final String message;

  const LoanOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}
