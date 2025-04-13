import 'package:equatable/equatable.dart';

import '../../../domain/entities/loan.dart';

abstract class LoanEvent extends Equatable {
  const LoanEvent();

  @override
  List<Object> get props => [];
}

class GetAllLoansEvent extends LoanEvent {}

class GetLoansWithRemindersEvent extends LoanEvent {}

class AddLoanEvent extends LoanEvent {
  final Loan loan;

  const AddLoanEvent(this.loan);

  @override
  List<Object> get props => [loan];
}

class UpdateLoanEvent extends LoanEvent {
  final Loan loan;

  const UpdateLoanEvent(this.loan);

  @override
  List<Object> get props => [loan];
}

class DeleteLoanEvent extends LoanEvent {
  final String id;

  const DeleteLoanEvent(this.id);

  @override
  List<Object> get props => [id];
}
