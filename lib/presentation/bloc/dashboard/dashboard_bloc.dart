import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/goal.dart';
import '../../../domain/entities/loan.dart';
import '../../../domain/usecases/category/get_all_categories.dart';
import '../../../domain/usecases/expense/get_expenses_by_date_range.dart';
import '../../../domain/usecases/goal/get_all_goals.dart';
import '../../../domain/usecases/loan/get_all_loans.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetExpensesByDateRange getExpensesByDateRange;
  final GetAllCategories getAllCategories;
  final GetAllGoals getAllGoals;
  final GetAllLoans getAllLoans;

  DashboardBloc({
    required this.getExpensesByDateRange,
    required this.getAllCategories,
    required this.getAllGoals,
    required this.getAllLoans,
  }) : super(const DashboardState()) {
    on<LoadDashboardDataEvent>(_onLoadDashboardData);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final DateTime startOfMonth =
        DateTime(event.month.year, event.month.month, 1);
    final DateTime endOfMonth =
        DateTime(event.month.year, event.month.month + 1, 0, 23, 59, 59);

    // Get expenses for the current month
    final expensesResult = await getExpensesByDateRange(
      Params(start: startOfMonth, end: endOfMonth),
    );

    // Get categories
    final categoriesResult = await getAllCategories(NoParams());

    // Get goals
    final goalsResult = await getAllGoals(NoParams());

    // Get loans
    final loansResult = await getAllLoans(NoParams());

    // Check if any request failed
    if (expensesResult.isLeft() ||
        categoriesResult.isLeft() ||
        goalsResult.isLeft() ||
        loansResult.isLeft()) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load dashboard data',
      ));
      return;
    }

    // Extract data from results
    final List<Expense> expenses = expensesResult.fold(
      (failure) => [],
      (expenses) => expenses,
    );

    final List<Category> categories = categoriesResult.fold(
      (failure) => [],
      (categories) => categories,
    );

    final List<Goal> goals = goalsResult.fold(
      (failure) => [],
      (goals) => goals,
    );

    final List<Loan> loans = loansResult.fold(
      (failure) => [],
      (loans) => loans,
    );

    // Calculate total monthly expense
    final double totalMonthlyExpense = expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    // Calculate expenses by category
    Map<Category, double> expensesByCategory = {};
    for (var expense in expenses) {
      final category = categories.firstWhere(
        (cat) => cat.id == expense.categoryId,
        orElse: () => const Category(
          id: 'unknown',
          name: 'Unknown',
          color: Color(0xFF9E9E9E),
          icon: Icons.help_outline,
        ),
      );

      if (expensesByCategory.containsKey(category)) {
        expensesByCategory[category] =
            expensesByCategory[category]! + expense.amount;
      } else {
        expensesByCategory[category] = expense.amount;
      }
    }

    // Calculate average monthly expense (from past 3 months)
    // Placeholder - In a real app you'd fetch past months data
    // For now just use current month as average
    final double averageMonthlyExpense = totalMonthlyExpense;

    // Filter active goals
    final List<Goal> activeGoals = goals
        .where((goal) =>
            goal.savedAmount < goal.targetAmount &&
            goal.endDate.isAfter(DateTime.now()))
        .toList();

    // Filter pending loans
    final List<Loan> pendingLoans =
        loans.where((loan) => !loan.isSettled).toList();

    emit(state.copyWith(
      isLoading: false,
      currentMonthExpenses: expenses,
      expensesByCategory: expensesByCategory,
      totalMonthlyExpense: totalMonthlyExpense,
      averageMonthlyExpense: averageMonthlyExpense,
      activeGoals: activeGoals,
      pendingLoans: pendingLoans,
    ));
  }
}
