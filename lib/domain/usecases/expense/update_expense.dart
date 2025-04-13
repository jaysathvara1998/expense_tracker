import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

class UpdateExpense implements UseCase<void, Expense> {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(Expense params) async {
    return await repository.updateExpense(params);
  }
}
