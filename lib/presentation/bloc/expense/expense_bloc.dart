import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/expense/add_expense.dart';
import '../../../domain/usecases/expense/delete_expense.dart' as delete;
import '../../../domain/usecases/expense/get_expenses_by_category.dart'
    as by_category;
import '../../../domain/usecases/expense/get_expenses_by_date_range.dart'
    as by_date_range;
import '../../../domain/usecases/expense/update_expense.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpense addExpense;
  final UpdateExpense updateExpense;
  final delete.DeleteExpense deleteExpense;
  final by_category.GetExpensesByCategory getExpensesByCategory;
  final by_date_range.GetExpensesByDateRange getExpensesByDateRange;

  ExpenseBloc({
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getExpensesByCategory,
    required this.getExpensesByDateRange,
  }) : super(ExpenseInitial()) {
    on<GetExpensesByDateRangeEvent>(_onGetExpensesByDateRange);
    on<GetExpensesByCategoryEvent>(_onGetExpensesByCategory);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onGetExpensesByDateRange(
    GetExpensesByDateRangeEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    final result = await getExpensesByDateRange(
      by_date_range.Params(start: event.start, end: event.end),
    );

    result.fold(
      (failure) =>
          emit(const ExpenseOperationFailure('Failed to load expenses')),
      (expenses) => emit(ExpensesLoaded(expenses)),
    );
  }

  Future<void> _onGetExpensesByCategory(
    GetExpensesByCategoryEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    final result = await getExpensesByCategory(
      by_category.Params(categoryId: event.categoryId),
    );

    result.fold(
      (failure) =>
          emit(const ExpenseOperationFailure('Failed to load expenses')),
      (expenses) => emit(ExpensesLoaded(expenses)),
    );
  }

  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    final result = await addExpense(event.expense);

    result.fold(
      (failure) => emit(const ExpenseOperationFailure('Failed to add expense')),
      (_) => emit(ExpenseOperationSuccess()),
    );
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    final result = await updateExpense(event.expense);

    result.fold(
      (failure) =>
          emit(const ExpenseOperationFailure('Failed to update expense')),
      (_) => emit(ExpenseOperationSuccess()),
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    final result = await deleteExpense(delete.Params(id: event.id));

    result.fold(
      (failure) =>
          emit(const ExpenseOperationFailure('Failed to delete expense')),
      (_) => emit(ExpenseOperationSuccess()),
    );
  }
}
