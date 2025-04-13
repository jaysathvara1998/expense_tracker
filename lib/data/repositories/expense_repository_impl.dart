import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDataSource dataSource;
  final NetworkInfo networkInfo;

  ExpenseRepositoryImpl({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Expense>>> getAllExpenses() async {
    if (await networkInfo.isConnected) {
      try {
        final expenses = await dataSource.getAllExpenses();
        return Right(expenses);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
      DateTime start, DateTime end) async {
    if (await networkInfo.isConnected) {
      try {
        final expenses = await dataSource.getExpensesByDateRange(start, end);
        return Right(expenses);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(
      String categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final expenses = await dataSource.getExpensesByCategory(categoryId);
        return Right(expenses);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final expense = await dataSource.getExpenseById(id);
        return Right(expense);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addExpense(Expense expense) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.addExpense(ExpenseModel.fromEntity(expense));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.updateExpense(ExpenseModel.fromEntity(expense));
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    if (await networkInfo.isConnected) {
      try {
        await dataSource.deleteExpense(id);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
