import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<Expense>>> getAllExpenses();
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
      DateTime start, DateTime end);
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(
      String categoryId);
  Future<Either<Failure, Expense>> getExpenseById(String id);
  Future<Either<Failure, void>> addExpense(Expense expense);
  Future<Either<Failure, void>> updateExpense(Expense expense);
  Future<Either<Failure, void>> deleteExpense(String id);
}
