import 'package:equatable/equatable.dart';

import '../../../domain/entities/expense.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpensesLoaded extends ExpenseState {
  final List<Expense> expenses;

  const ExpensesLoaded(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class ExpenseOperationSuccess extends ExpenseState {}

class ExpenseOperationFailure extends ExpenseState {
  final String message;

  const ExpenseOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}
