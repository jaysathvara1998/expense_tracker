import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/loan.dart';
import '../../repositories/loan_repository.dart';

class UpdateLoan implements UseCase<void, Loan> {
  final LoanRepository repository;

  UpdateLoan(this.repository);

  @override
  Future<Either<Failure, void>> call(Loan params) async {
    return await repository.updateLoan(params);
  }
}
