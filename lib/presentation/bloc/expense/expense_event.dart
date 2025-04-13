import 'package:equatable/equatable.dart';

import '../../../domain/entities/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetAllExpensesEvent extends ExpenseEvent {}

class GetExpensesByDateRangeEvent extends ExpenseEvent {
  final DateTime start;
  final DateTime end;

  const GetExpensesByDateRangeEvent({
    required this.start,
    required this.end,
  });

  @override
  List<Object> get props => [start, end];
}

class GetExpensesByCategoryEvent extends ExpenseEvent {
  final String categoryId;

  const GetExpensesByCategoryEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class AddExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const AddExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent(this.expense);

  @override
  List<Object> get props => [expense];
}

class DeleteExpenseEvent extends ExpenseEvent {
  final String id;

  const DeleteExpenseEvent(this.id);

  @override
  List<Object> get props => [id];
}
