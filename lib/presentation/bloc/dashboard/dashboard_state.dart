// lib/presentation/bloc/dashboard/dashboard_state.dart
import 'package:equatable/equatable.dart';

import '../../../domain/entities/category.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/goal.dart';
import '../../../domain/entities/loan.dart';

class DashboardState extends Equatable {
  final bool isLoading;
  final List<Expense> currentMonthExpenses;
  final Map<Category, double> expensesByCategory;
  final double totalMonthlyExpense;
  final double averageMonthlyExpense;
  final List<Goal> activeGoals;
  final List<Loan> pendingLoans;
  final String? error;

  const DashboardState({
    this.isLoading = true,
    this.currentMonthExpenses = const [],
    this.expensesByCategory = const {},
    this.totalMonthlyExpense = 0.0,
    this.averageMonthlyExpense = 0.0,
    this.activeGoals = const [],
    this.pendingLoans = const [],
    this.error,
  });

  DashboardState copyWith({
    bool? isLoading,
    List<Expense>? currentMonthExpenses,
    Map<Category, double>? expensesByCategory,
    double? totalMonthlyExpense,
    double? averageMonthlyExpense,
    List<Goal>? activeGoals,
    List<Loan>? pendingLoans,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      currentMonthExpenses: currentMonthExpenses ?? this.currentMonthExpenses,
      expensesByCategory: expensesByCategory ?? this.expensesByCategory,
      totalMonthlyExpense: totalMonthlyExpense ?? this.totalMonthlyExpense,
      averageMonthlyExpense:
          averageMonthlyExpense ?? this.averageMonthlyExpense,
      activeGoals: activeGoals ?? this.activeGoals,
      pendingLoans: pendingLoans ?? this.pendingLoans,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        currentMonthExpenses,
        expensesByCategory,
        totalMonthlyExpense,
        averageMonthlyExpense,
        activeGoals,
        pendingLoans,
        error
      ];
}
