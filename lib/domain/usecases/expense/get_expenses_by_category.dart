import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

class GetExpensesByCategory implements UseCase<List<Expense>, Params> {
  final ExpenseRepository repository;

  GetExpensesByCategory(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(Params params) async {
    return await repository.getExpensesByCategory(params.categoryId);
  }
}

class Params extends Equatable {
  final String categoryId;

  const Params({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
