import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/loan.dart';
import '../../repositories/loan_repository.dart';

class GetAllLoans implements UseCase<List<Loan>, NoParams> {
  final LoanRepository repository;

  GetAllLoans(this.repository);

  @override
  Future<Either<Failure, List<Loan>>> call(NoParams params) async {
    return await repository.getAllLoans();
  }
}
