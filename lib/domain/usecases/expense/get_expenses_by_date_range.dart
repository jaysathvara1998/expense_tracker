import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

class GetExpensesByDateRange implements UseCase<List<Expense>, Params> {
  final ExpenseRepository repository;

  GetExpensesByDateRange(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(Params params) async {
    return await repository.getExpensesByDateRange(params.start, params.end);
  }
}

class Params extends Equatable {
  final DateTime start;
  final DateTime end;

  const Params({required this.start, required this.end});

  @override
  List<Object> get props => [start, end];
}
