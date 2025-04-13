import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/loan.dart';
import '../../repositories/loan_repository.dart';

class GetLoansWithReminders implements UseCase<List<Loan>, NoParams> {
  final LoanRepository repository;

  GetLoansWithReminders(this.repository);

  @override
  Future<Either<Failure, List<Loan>>> call(NoParams params) async {
    return await repository.getLoansWithReminders();
  }
}
