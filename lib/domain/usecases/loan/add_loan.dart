import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/loan.dart';
import '../../repositories/loan_repository.dart';

class AddLoan implements UseCase<void, Loan> {
  final LoanRepository repository;

  AddLoan(this.repository);

  @override
  Future<Either<Failure, void>> call(Loan params) async {
    return await repository.addLoan(params);
  }
}
